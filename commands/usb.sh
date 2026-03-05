# =============================================================================
# commands/usb.sh — USB Mode with Aggressive Fallback
# =============================================================================

function cmd.usb() {
    local allow_fallback="${1:-false}"
    local label="${SELECTED_NICKNAME:-Device}"

    # Setup Wireless Standby jika belum siap
    if [ "$allow_fallback" = "true" ] && [ -z "$WIFI_TARGET" ]; then
        log.info "Menyiapkan Wireless Standby..."
        local ip; ip=$(device.get_wifi_ip "$SELECTED_SERIAL" || true)
        if [ -n "$ip" ]; then
            "$ADB" -s "$SELECTED_SERIAL" tcpip "$ADB_PORT" &>/dev/null
            sleep 2
            wireless.connect "$ip" &>/dev/null || true
        fi
    fi

    log.ok "Running via USB: ${label}"
    
    set +e
    scrcpy.run "$SELECTED_SERIAL" "$label"
    local exit_code=$?
    set -e

    # Jika putus (kebanyakan exit code > 0 saat unplug/crash)
    if [ "$allow_fallback" = "true" ]; then
        if [ -n "$WIFI_TARGET" ]; then
            log.warn "Koneksi USB terputus. Automatis pindah ke WiFi: ${WIFI_TARGET}..."
            sleep 2
            scrcpy.run "$WIFI_TARGET" "$label (WiFi)"
            return $?
        else
            log.error "USB terputus dan Wireless Standby tidak siap."
            return 1
        fi
    fi

    return $exit_code
}
