# =============================================================================
# lib/core.sh — Bootstrap & Command Router
# =============================================================================

function boot() {
    local dir="$SCRIPT_DIR"
    source "${dir}/config.sh"
    source "${dir}/lib/state.sh"
    source "${dir}/lib/colors.sh"
    source "${dir}/lib/throw.sh"
    source "${dir}/lib/device.sh"
    source "${dir}/lib/registry.sh"
    source "${dir}/lib/network.sh"
    source "${dir}/lib/picker.sh"
    source "${dir}/lib/settings.sh"
    source "${dir}/lib/persistence.sh"
    source "${dir}/lib/wireless.sh"
    source "${dir}/lib/scrcpy.sh"
    persistence.load
    source "${dir}/commands/auto.sh"
    source "${dir}/commands/usb.sh"
    source "${dir}/commands/wifi.sh"
    source "${dir}/commands/list.sh"
    source "${dir}/commands/save.sh"
    source "${dir}/commands/forget.sh"
    source "${dir}/commands/rename.sh"
    source "${dir}/commands/use.sh"
    source "${dir}/commands/pick.sh"
    source "${dir}/commands/help.sh"
    registry.init
}

function runner.loop() {
    local cmd_fn="$1"
    shift
    while true; do
        $cmd_fn "$@" || true
        sleep 2
    done
}



function route() {
    local cmd="${1:-auto}"
    shift 2>/dev/null || true

    # Header
    echo -e "\n${BLUE}${BOLD}  Android Connect${NC}  ${DIM}v3.9 | Pro Edition | Persistent Mode${NC}\n"

    # Commands yang tidak butuh ADB/Scrcpy
    case "$cmd" in
        help|--help|-h) cmd.help;        return ;;
        list)           cmd.list "$@";   return ;;
        forget)         cmd.forget "$@"; return ;;
        rename)         cmd.rename "$@"; return ;;
    esac

    # Validasi tools untuk semua command lainnya
    device.validate_tools

    case "$cmd" in
        auto|"")  runner.loop cmd.auto "$@" ;;
        pick)     runner.loop cmd.pick "$@" ;;
        
        # Perintah Dasar
        usb)      runner.loop cmd.usb "true" "$@" ;;
        wifi)     runner.loop cmd.wifi "$@"       ;;
        save)     cmd.save "$@"                   ;;
        use)      runner.loop cmd.use "$@"        ;;

        *)
            echo -e "${RED}Command tidak dikenal: '${cmd}'${NC}"
            cmd.help
            exit 1
            ;;
    esac
}
