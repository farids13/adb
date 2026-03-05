# =============================================================================
# lib/state.sh — Global Settings & State
# =============================================================================
WIFI_TARGET=""
SELECTED_SERIAL=""
SELECTED_NICKNAME=""
FORCE_PICK="false"
SELECTED_PROFILE_FLAGS=""
SELECTED_PROFILE_NAME=""
SET_SHOW_HELP="false"

# --- VIDEO SETTINGS ---
SET_VIDEO_ON="true"           # Mirroring video?
SET_MAX_SIZE="0"              # 0 = native (1024, 1440, etc)
SET_BITRATE="8M"
SET_CODEC="h264"              # h264, h265, av1
SET_MAX_FPS="0"               # 0 = max
SET_VIDEO_SOURCE="display"    # display | camera

# --- AUDIO SETTINGS ---
SET_AUDIO_ON="true"
SET_AUDIO_SOURCE="output"     # output, mic
SET_AUDIO_BITRATE="128K"

# --- WINDOW & DISPLAY ---
SET_STAY_AWAKE="true"         # --stay-awake
SET_SCREEN_OFF="true"         # --turn-screen-off
SET_BORDERLESS="false"        # --window-borderless
SET_ALWAYS_ON_TOP="false"     # --always-on-top
SET_FULLSCREEN="false"        # --fullscreen
SET_NO_WINDOW="false"         # --no-window

# --- CONTROL & TOOLS ---
SET_CONTROL_ON="true"         # --no-control
SET_UHID_MODE="false"         # --keyboard=uhid --mouse=uhid
SET_RECORDING="false"         # --record
