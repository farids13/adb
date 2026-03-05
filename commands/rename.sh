# =============================================================================
# commands/rename.sh — Ganti nickname device di registry
# =============================================================================

function cmd.rename() {
    local old_name="${1:-}" new_name="${2:-}"
    [ -z "$old_name" ] || [ -z "$new_name" ] && throw 1 \
        "Gunakan: ./android rename <nama-lama> <nama-baru>"

    local serial; serial=$(registry.find_serial "$old_name" || true)
    [ -z "$serial" ] && throw 1 "Device '${old_name}' tidak ditemukan." \
        "Cek: ./android list"

    local ip; ip=$(registry.get_ip "$serial" || echo "")
    registry.save "$serial" "$new_name" "$ip"
    log.ok "Renamed: '${old_name}' → '${new_name}'"
}
