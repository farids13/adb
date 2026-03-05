# =============================================================================
# commands/pick.sh — Paksa tampilkan picker interaktif lalu auto mode
# =============================================================================

function cmd.pick() {
    FORCE_PICK=true
    picker.select
    cmd.auto "$@"
}
