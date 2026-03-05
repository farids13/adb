# =============================================================================
# commands/forget.sh — Hapus device dari registry
# =============================================================================

function cmd.forget() {
    local query="${1:-}"
    [ -z "$query" ] && throw 1 "Masukkan nickname atau serial." \
        "Gunakan: ./android forget <nama>"

    registry.forget "$query" \
        && log.ok "Device '${query}' dihapus dari registry." \
        || throw 1 "Device '${query}' tidak ditemukan." \
            "Cek: ./android list"
}
