# =============================================================================
# lib/throw.sh — Centralized Error Handler
# =============================================================================
function throw() {
    local code="${1:-1}" msg="${2:-Unknown error}" hint="${3:-}"
    echo -e "\n${RED}${BOLD}╔══════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║           ❌  FATAL ERROR             ║${NC}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════╝${NC}"
    echo -e "${RED}${BOLD}Pesan :${NC} ${msg}"
    [ -n "$hint" ] && echo -e "${YELLOW}${BOLD}Solusi:${NC} ${hint}"
    echo -e "${RED}${BOLD}Kode  :${NC} exit ${code}\n"
    exit "$code"
}
