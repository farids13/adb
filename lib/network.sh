# =============================================================================
# lib/network.sh — Network Validation
# =============================================================================

function network.get_mac_ip() {
    local ip=""
    for iface in en0 en1 en2 en3; do
        ip=$(ipconfig getifaddr "$iface" 2>/dev/null || true)
        if [ -n "$ip" ] && [[ "$ip" != "127."* ]]; then
            echo "$ip"; return 0
        fi
    done
    return 1
}

function network.validate() {
    local device_ip="$1"
    local mac_ip
    mac_ip=$(network.get_mac_ip || true)
    [ -z "$mac_ip" ] && throw 20 \
        "Mac tidak terhubung ke WiFi manapun." \
        "Hubungkan Mac ke WiFi yang sama dengan HP."

    local hp_sub mac_sub
    hp_sub=$(echo "$device_ip" | cut -d. -f1-3)
    mac_sub=$(echo "$mac_ip"   | cut -d. -f1-3)
    log.info "Subnet Mac : ${mac_sub}.x  (${mac_ip})"
    log.info "Subnet HP  : ${hp_sub}.x  (${device_ip})"

    [ "$hp_sub" != "$mac_sub" ] && throw 50 \
        "Mac (${mac_ip}) dan HP (${device_ip}) berbeda jaringan!" \
        "$(printf 'Solusi:\n        1. Hubungkan ke WiFi yang sama\n        2. Aktifkan Hotspot HP → Mac konek ke hotspot\n        3. Atau: ./android usb')"
    log.ok "Subnet sama ✓"

    ping -c 2 -W 2 "$device_ip" &>/dev/null || throw 51 \
        "HP (${device_ip}) tidak bisa di-ping dari Mac." \
        "Kemungkinan AP Isolation aktif di router."
    log.ok "Ping berhasil ✓"
}
