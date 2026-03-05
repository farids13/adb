# =============================================================================
# lib/wireless.sh — ADB Wireless Connection Manager
# =============================================================================

# Connect ADB ke IP:PORT. Set global WIFI_TARGET jika berhasil.
function wireless.connect() {
    local ip="$1"
    local target="${ip}:${ADB_PORT}"
    "$ADB" disconnect "$target" &>/dev/null || true

    local result
    result=$("$ADB" connect "$target" 2>&1 || true)
    log.info "ADB connect: ${result}"
    echo "$result" | grep -qi "failed\|unable\|refused\|error" && return 1

    local elapsed=0
    while [ $elapsed -lt $CONNECT_TIMEOUT ]; do
        if device.is_reachable "$target"; then
             WIFI_TARGET="$target"
             # Update registry HANYA jika serial terpilih adalah USB Serial (bukan IP)
             if [[ "$SELECTED_SERIAL" != *":"* ]]; then
                 registry.upsert_ip "$SELECTED_SERIAL" "$ip"
             fi
             log.ok "ADB Wireless aktif: ${target} ✓"
             return 0
        fi
        sleep 1; elapsed=$((elapsed + 1))
    done
    return 1
}

# Pancingan USB → buka tcpip → connect wireless. Set WIFI_TARGET.
function wireless.bait() {
    local serial="$1"
    log.step "Pancingan: Membuka port TCP ${ADB_PORT} via USB..."

    local tcpip_result
    tcpip_result=$("$ADB" -s "$serial" tcpip "$ADB_PORT" 2>&1 || true)
    log.info "ADB tcpip: ${tcpip_result}"
    echo "$tcpip_result" | grep -qi "error\|failed\|cannot" && throw 60 \
        "Gagal membuka port TCP: ${tcpip_result}" \
        "Cabut dan colok ulang kabel USB."

    log.info "Menunggu HP siap menerima koneksi wireless..."
    sleep 3

    local device_ip
    device_ip=$(device.get_wifi_ip "$serial" || true)
    [ -z "$device_ip" ] && throw 40 \
        "Gagal mendapatkan IP address HP." \
        "Pastikan HP terhubung ke WiFi (bukan 4G)."

    log.ok "IP HP: ${device_ip}"
    network.validate "$device_ip"
    wireless.connect "$device_ip" || throw 62 \
        "Koneksi wireless ke ${device_ip}:${ADB_PORT} gagal." \
        "Cek AP Isolation di router."
}

# Fallback setelah USB disconnect. Set WIFI_TARGET.
function wireless.fallback() {
    local serial="${1:-}" known_ip="${2:-}"
    log.step "WiFi Fallback: beralih ke wireless..."

    local target_ip="$known_ip"
    if [ -z "$target_ip" ] && [ -n "$serial" ]; then
        target_ip=$(registry.get_ip "$serial" || true)
        [ -n "$target_ip" ] && log.info "IP dari registry: ${target_ip}"
    fi

    local current_usb
    current_usb=$(device.get_all_usb | head -1 || true)

    if [ -n "$current_usb" ]; then
        log.info "USB masih terdeteksi → pancingan tcpip..."
        wireless.bait "$current_usb"
    elif [ -n "$target_ip" ]; then
        log.info "USB dicabut → connect langsung ke ${target_ip}:${ADB_PORT}"
        wireless.connect "$target_ip" || throw 62 \
            "Gagal reconnect ke ${target_ip}:${ADB_PORT}." \
            "Colok USB lagi dan jalankan: ./android wifi"
    else
        throw 63 "Tidak ada IP yang diketahui untuk fallback WiFi." \
            "Colok USB dan jalankan: ./android wifi"
    fi
}
