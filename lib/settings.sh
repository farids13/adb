# =============================================================================
# lib/settings.sh — Dasbor Konfigurasi Profesional (Edisi Lengkap)
# =============================================================================

function settings.toggle() {
    local key="$1"
    local current="${!key}"
    if [ "$current" = "true" ]; then eval "${key}=\"false\""; else eval "${key}=\"true\""; fi
}

function settings.reset() {
    SET_VIDEO_ON="true"
    SET_MAX_SIZE="0"
    SET_BITRATE="8M"
    SET_CODEC="h264"
    SET_MAX_FPS="0"
    SET_AUDIO_ON="true"
    SET_AUDIO_SOURCE="output"     # output | mic
    SET_VIDEO_SOURCE="display"    # display | camera
    SET_AUDIO_BITRATE="128K"
    SET_STAY_AWAKE="true"
    SET_SCREEN_OFF="true"
    SET_BORDERLESS="false"
    SET_ALWAYS_ON_TOP="false"
    SET_FULLSCREEN="false"
    SET_NO_WINDOW="false"
    SET_CONTROL_ON="true"
    SET_UHID_MODE="false"
    SET_RECORDING="false"
}

function settings.get_flags() {
    local flags=""
    local ctrl="true"
    [ "$SET_CONTROL_ON" = "false" ] || [ "$SET_NO_WINDOW" = "true" ] && ctrl="false"

    # --- 1. CORE CONTROL ---
    [ "$ctrl" = "false" ] && flags+=" --no-control"

    # --- 2. VIDEO SETTINGS ---
    if [ "$SET_VIDEO_ON" = "false" ]; then flags+=" --no-video"; else
        flags+=" --video-source=${SET_VIDEO_SOURCE}"
        [ "$SET_MAX_SIZE" != "0" ]  && flags+=" --max-size=${SET_MAX_SIZE}"
        [ "$SET_BITRATE" != "8M" ]  && flags+=" --video-bit-rate=${SET_BITRATE}"
        [ "$SET_CODEC" != "h264" ]  && flags+=" --video-codec=${SET_CODEC}"
        [ "$SET_MAX_FPS" != "0" ]   && flags+=" --max-fps=${SET_MAX_FPS}"
    fi

    # --- 3. AUDIO SETTINGS ---
    if [ "$SET_AUDIO_ON" = "false" ]; then flags+=" --no-audio"; else
        flags+=" --audio-source=${SET_AUDIO_SOURCE}"
        [ "$SET_AUDIO_BITRATE" != "128K" ] && flags+=" --audio-bit-rate=${SET_AUDIO_BITRATE}"
    fi

    # --- 4. DISPLAY & WINDOW ---
    if [ "$ctrl" = "true" ]; then
        [ "$SET_SCREEN_OFF" = "true" ] && flags+=" --turn-screen-off"
        [ "$SET_STAY_AWAKE" = "true" ] && flags+=" --stay-awake"
    fi
    [ "$SET_BORDERLESS" = "true" ]     && flags+=" --window-borderless"
    [ "$SET_ALWAYS_ON_TOP" = "true" ]  && flags+=" --always-on-top"
    [ "$SET_FULLSCREEN" = "true" ]     && flags+=" --fullscreen"
    [ "$SET_NO_WINDOW" = "true" ]      && flags+=" --no-window"

    # --- 5. INPUT & RECORDING ---
    [ "$SET_UHID_MODE" = "true" ] && [ "$ctrl" = "true" ] && flags+=" --keyboard=uhid --mouse=uhid"
    if [ "$SET_RECORDING" = "true" ]; then
        local rectime; rectime=$(date +%Y%m%d_%H%M%S)
        flags+=" --record=rec_${rectime}.mp4"
    fi

    echo "$flags"
}

function settings.menu() {
    SELECTED_PROFILE_FLAGS=""
    while true; do
        clear
        echo -e "${BLUE}${BOLD}📱 DASBOR ANDROID PRO ${NC}${DIM}v3.9 (Feature Complete)${NC}"
        echo -e "${DIM}──────────────────────────────────────────────────${NC}"
        
        echo -e "${YELLOW}${BOLD}  [A] Visual & Output${NC}"
        echo -e "      ${BOLD}1${NC}. Layar HP Mati   : $([ "$SET_SCREEN_OFF" = "true" ] && echo -e "${GREEN}AKTIF${NC}" || echo -e "${DIM}OFF${NC}")"
        echo -e "      ${BOLD}2${NC}. Tanpa Bingkai   : $([ "$SET_BORDERLESS" = "true" ] && echo -e "${GREEN}AKTIF${NC}" || echo -e "${DIM}OFF${NC}")"
        echo -e "      ${BOLD}3${NC}. Sumber Video    : ${CYAN}${SET_VIDEO_SOURCE}${NC} (Display/Camera)"
        echo -e "      ${BOLD}4${NC}. Limit FPS       : ${BOLD}$([ "$SET_MAX_FPS" = "0" ] && echo "MAX" || echo "$SET_MAX_FPS")${NC}"
        echo -e "      ${BOLD}5${NC}. Layar Penuh     : $([ "$SET_FULLSCREEN" = "true" ] && echo -e "${GREEN}AKTIF${NC}" || echo -e "${DIM}OFF${NC}")"
        
        echo -e "\n${YELLOW}${BOLD}  [B] Media & Transmisi${NC}"
        echo -e "      ${BOLD}6${NC}. Mirror Video    : $([ "$SET_VIDEO_ON" = "true" ] && echo -e "${GREEN}ON${NC}" || echo -e "${RED}OFF${NC}")"
        echo -e "      ${BOLD}7${NC}. Mirror Audio    : $([ "$SET_AUDIO_ON" = "true" ] && echo -e "${GREEN}ON${NC}" || echo -e "${RED}OFF${NC}")"
        echo -e "      ${BOLD}8${NC}. Sumber Audio    : ${CYAN}${SET_AUDIO_SOURCE}${NC} (System/Mic)"
        echo -e "      ${BOLD}9${NC}. Bitrate Video   : ${BOLD}${SET_BITRATE}${NC}"
        
        echo -e "\n${YELLOW}${BOLD}  [C] Pro Tools & Input${NC}"
        echo -e "      ${BOLD}0${NC}. Rekam Layar     : $([ "$SET_RECORDING" = "true" ] && echo -e "${RED}${BOLD}[RECORDING]${NC}" || echo -e "${DIM}OFF${NC}")"
        echo -e "      ${BOLD}u${NC}. UHID Smooth     : $([ "$SET_UHID_MODE" = "true" ] && echo -e "${GREEN}AKTIF${NC}" || echo -e "${DIM}OFF${NC}")"
        echo -e "      ${BOLD}g${NC}. Mode Siluman    : $([ "$SET_NO_WINDOW" = "true" ] && echo -e "${GREEN}AKTIF${NC}" || echo -e "${DIM}OFF${NC}")"
        
        echo -e "${DIM}──────────────────────────────────────────────────${NC}"
        echo -e "${GREEN}${BOLD}  [ENTER] MULAI KONEKSI${NC} ${DIM}| [h] Bantuan | [q] Keluar${NC}"
        echo -e "${DIM}──────────────────────────────────────────────────${NC}"

        if [ "$SET_SHOW_HELP" = "true" ]; then
            echo -e "${CYAN}${BOLD}📖 PANDUAN FITUR LENGKAP:${NC}"
            echo -e "  • ${BOLD}Tombol 3${NC} : Gunakan HP sebagai Webcam (Camera Forwarding)."
            echo -e "  • ${BOLD}Tombol 8${NC} : Pindah suara dari Output HP ke Mic HP."
            echo -e "  • ${BOLD}Tombol 0${NC} : Simpan mirroring ke file .mp4 otomatis."
            echo -e "  • ${BOLD}Tombol 4${NC} : Batasi FPS (40/60/MAX) untuk hemat data."
            echo -e "${DIM}──────────────────────────────────────────────────${NC}"
        fi

        IFS= read -n 1 -s char </dev/tty
        case "$char" in
            1) settings.toggle "SET_SCREEN_OFF" ;;
            2) settings.toggle "SET_BORDERLESS" ;;
            3) [ "$SET_VIDEO_SOURCE" = "display" ] && SET_VIDEO_SOURCE="camera" || SET_VIDEO_SOURCE="display" ;;
            4) case "$SET_MAX_FPS" in "0") SET_MAX_FPS="30" ;; "30") SET_MAX_FPS="60" ;; "60") SET_MAX_FPS="0" ;; esac ;;
            5) settings.toggle "SET_FULLSCREEN" ;;
            6) settings.toggle "SET_VIDEO_ON" ;;
            7) settings.toggle "SET_AUDIO_ON" ;;
            8) [ "$SET_AUDIO_SOURCE" = "output" ] && SET_AUDIO_SOURCE="mic" || SET_AUDIO_SOURCE="output" ;;
            9) case "$SET_BITRATE" in "4M") SET_BITRATE="8M" ;; "8M") SET_BITRATE="16M" ;; "16M") SET_BITRATE="32M" ;; "32M") SET_BITRATE="4M" ;; *) SET_BITRATE="8M" ;; esac ;;
            0) settings.toggle "SET_RECORDING" ;;
            u) settings.toggle "SET_UHID_MODE" ;;
            g) settings.toggle "SET_NO_WINDOW" ;;
            h) settings.toggle "SET_SHOW_HELP" ;;
            "") break ;; 
            q) exit 0 ;;
        esac
    done
    SELECTED_PROFILE_FLAGS=$(settings.get_flags)
}
