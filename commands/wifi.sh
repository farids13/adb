# =============================================================================
# commands/wifi.sh — WiFi Mode
# Coba registry IP dulu. Jika gagal → pancingan USB.
# =============================================================================

function cmd.wifi() {
    # Set target by name jika diberikan
    if [ -n "${1:-}" ]; then
        local serial; serial=$(registry.find_serial "$1" || true)
        [ -n "$serial" ] \
            && SELECTED_SERIAL="$serial" \
            && SELECTED_NICKNAME=$(registry.get_nickname "$serial" || echo "$1")
    fi

    log.step "[WiFi] Memulai koneksi wireless..."
    local mac_ip; mac_ip=$(network.get_mac_ip || true)
    [ -z "$mac_ip" ] && throw 20 "Mac tidak terhubung ke WiFi."
    log.ok "IP Mac: ${mac_ip}"

    # 1. KASUS: Target sudah berupa IP:PORT (dari Smart Picker)
    if [[ "$SELECTED_SERIAL" == *":"* ]]; then
        WIFI_TARGET="$SELECTED_SERIAL"
        local ip_only; ip_only=$(echo "$WIFI_TARGET" | cut -d: -f1)
        log.info "Direct connect: ${WIFI_TARGET}..."
        if wireless.connect "$ip_only"; then
             local label="${SELECTED_NICKNAME:-WiFi}"
             set +e; scrcpy.run "$WIFI_TARGET" "${label} (WiFi)"; local sc_ex=$?; set -e
             [ $sc_ex -eq 0 ] && return 0
        fi
    fi

    # 2. KASUS: Serial terdeteksi, coba IP registry
    if [ -n "$SELECTED_SERIAL" ] && [[ "$SELECTED_SERIAL" != *":"* ]]; then
        local cached_ip; cached_ip=$(registry.get_ip "$SELECTED_SERIAL" || true)
        if [ -n "$cached_ip" ]; then
            if ping -c 1 -W 1 "$cached_ip" &>/dev/null; then
                log.info "Mencoba IP dari registry: ${cached_ip}"
                if wireless.connect "$cached_ip"; then
                    local label="${SELECTED_NICKNAME:-WiFi}"
                    set +e; scrcpy.run "$WIFI_TARGET" "${label} (WiFi)"; local sc_ex=$?; set -e
                    [ $sc_ex -eq 0 ] && return 0
                fi
            fi
        fi
    fi

    # 3. KASUS: Gagal semua atau belum ada serial → Pancingan USB
    [ -z "$SELECTED_SERIAL" ] || [[ "$SELECTED_SERIAL" == *":"* ]] && picker.select
    
    # Pastikan SELECTED_SERIAL sekarang adalah USB SERIAL (bukan IP)
    if [[ "$SELECTED_SERIAL" == *":"* ]]; then
        # Jika picker masih return IP tapi gagal connect, kita butuh USB
        log.warn "Koneksi WiFi langsung gagal. Silakan colok USB untuk pancingan."
        return 1
    fi

    device.validate_android "$SELECTED_SERIAL"
    wireless.bait "$SELECTED_SERIAL"

    log.ok "Pancingan sukses! Cabut USB aman."
    sleep 2

    local label="${SELECTED_NICKNAME:-WiFi}"
    set +e; scrcpy.run "$WIFI_TARGET" "${label} (WiFi)"; set -e
    return 0
}
