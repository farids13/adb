# =============================================================================
# lib/persistence.sh — Simpan & Muat Konfigurasi (JSON)
# =============================================================================

LAST_CONFIG_FILE="${SCRIPT_DIR}/.last_config.json"

function persistence.save() {
    if ! command -v jq &>/dev/null; then return 0; fi
    
    # Ambil semua variabel SET_* dan simpan ke JSON
    jq -n \
        --arg video_on "$SET_VIDEO_ON" \
        --arg max_size "$SET_MAX_SIZE" \
        --arg bitrate "$SET_BITRATE" \
        --arg codec "$SET_CODEC" \
        --arg max_fps "$SET_MAX_FPS" \
        --arg video_source "$SET_VIDEO_SOURCE" \
        --arg audio_on "$SET_AUDIO_ON" \
        --arg audio_source "$SET_AUDIO_SOURCE" \
        --arg audio_bitrate "$SET_AUDIO_BITRATE" \
        --arg stay_awake "$SET_STAY_AWAKE" \
        --arg screen_off "$SET_SCREEN_OFF" \
        --arg borderless "$SET_BORDERLESS" \
        --arg always_on_top "$SET_ALWAYS_ON_TOP" \
        --arg fullscreen "$SET_FULLSCREEN" \
        --arg no_window "$SET_NO_WINDOW" \
        --arg control_on "$SET_CONTROL_ON" \
        --arg uhid_mode "$SET_UHID_MODE" \
        --arg recording "$SET_RECORDING" \
        --arg show_help "$SET_SHOW_HELP" \
        --arg last_serial "$SELECTED_SERIAL" \
        --arg last_nickname "$SELECTED_NICKNAME" \
        '{
            video_on: $video_on,
            max_size: $max_size,
            bitrate: $bitrate,
            codec: $codec,
            max_fps: $max_fps,
            video_source: $video_source,
            audio_on: $audio_on,
            audio_source: $audio_source,
            audio_bitrate: $audio_bitrate,
            stay_awake: $stay_awake,
            screen_off: $screen_off,
            borderless: $borderless,
            always_on_top: $always_on_top,
            fullscreen: $fullscreen,
            no_window: $no_window,
            control_on: $control_on,
            uhid_mode: $uhid_mode,
            recording: $recording,
            show_help: $show_help,
            last_serial: $last_serial,
            last_nickname: $last_nickname
        }' > "$LAST_CONFIG_FILE"
}

function persistence.load() {
    if [ ! -f "$LAST_CONFIG_FILE" ] || ! command -v jq &>/dev/null; then
        return 0
    fi

    # Pastikan file JSON valid
    if ! jq empty "$LAST_CONFIG_FILE" &>/dev/null; then
        return 0
    fi

    local data; data=$(cat "$LAST_CONFIG_FILE")
    
    SET_VIDEO_ON=$(echo "$data" | jq -r '.video_on // "true"')
    SET_MAX_SIZE=$(echo "$data" | jq -r '.max_size // "0"')
    SET_BITRATE=$(echo "$data" | jq -r '.bitrate // "8M"')
    SET_CODEC=$(echo "$data" | jq -r '.codec // "h264"')
    SET_MAX_FPS=$(echo "$data" | jq -r '.max_fps // "0"')
    SET_VIDEO_SOURCE=$(echo "$data" | jq -r '.video_source // "display"')
    SET_AUDIO_ON=$(echo "$data" | jq -r '.audio_on // "true"')
    SET_AUDIO_SOURCE=$(echo "$data" | jq -r '.audio_source // "output"')
    SET_AUDIO_BITRATE=$(echo "$data" | jq -r '.audio_bitrate // "128K"')
    SET_STAY_AWAKE=$(echo "$data" | jq -r '.stay_awake // "true"')
    SET_SCREEN_OFF=$(echo "$data" | jq -r '.screen_off // "true"')
    SET_BORDERLESS=$(echo "$data" | jq -r '.borderless // "false"')
    SET_ALWAYS_ON_TOP=$(echo "$data" | jq -r '.always_on_top // "false"')
    SET_FULLSCREEN=$(echo "$data" | jq -r '.fullscreen // "false"')
    SET_NO_WINDOW=$(echo "$data" | jq -r '.no_window // "false"')
    SET_CONTROL_ON=$(echo "$data" | jq -r '.control_on // "true"')
    SET_UHID_MODE=$(echo "$data" | jq -r '.uhid_mode // "false"')
    SET_RECORDING=$(echo "$data" | jq -r '.recording // "false"')
    SET_SHOW_HELP=$(echo "$data" | jq -r '.show_help // "false"')
    
    # Load last device if not already set by cli args
    [ -z "$SELECTED_SERIAL" ] && SELECTED_SERIAL=$(echo "$data" | jq -r '.last_serial // ""')
    [ -z "$SELECTED_NICKNAME" ] && SELECTED_NICKNAME=$(echo "$data" | jq -r '.last_nickname // ""')
}
