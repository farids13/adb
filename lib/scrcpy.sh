# =============================================================================
# lib/scrcpy.sh — Scrcpy Runner
# =============================================================================

# Jalankan scrcpy audio-only. Return exit code asli (tidak throw).
function scrcpy.run() {
    local serial="$1" label="${2:-scrcpy}"
    log.step "Inisialisasi Mirroring — ${label}"
    log.info "ID Perangkat : ${serial}"
    log.info "Bitrate Audio: ${SCRCPY_AUDIO_BITRATE}"
    log.info "Tekan CTRL+C untuk mengakhiri sesi."
    echo ""

    set +e
    "$SCRCPY" \
        --serial "$serial" \
        $SELECTED_PROFILE_FLAGS \
        --audio-bit-rate "$SCRCPY_AUDIO_BITRATE"
    local sc_exit=$?
    set -e
    return $sc_exit
}
