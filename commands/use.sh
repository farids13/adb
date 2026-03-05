# =============================================================================
# commands/use.sh — Connect ke device by nickname, lalu jalankan mode tertentu
# =============================================================================

function cmd.use() {
    local query="${1:-}" conn_mode="${2:-auto}"
    [ -z "$query" ] && throw 1 "Masukkan nickname atau serial." \
        "Gunakan: ./android use <nama> [usb|wifi|auto]"

    local serial; serial=$(registry.find_serial "$query" || true)
    [ -z "$serial" ] && throw 1 "Device '${query}' tidak ditemukan di registry." \
        "Simpan dulu: ./android save <nama>"

    SELECTED_SERIAL="$serial"
    SELECTED_NICKNAME=$(registry.get_nickname "$serial" || echo "$query")
    log.ok "Target: ${SELECTED_NICKNAME} (${SELECTED_SERIAL})"

    case "$conn_mode" in
        usb)  cmd.usb "true" ;;
        wifi) cmd.wifi       ;;
        *)    cmd.auto       ;;
    esac
}
