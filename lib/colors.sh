# =============================================================================
# lib/colors.sh — Sistem Pewarnaan & Log Profesional
# =============================================================================

NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

function log.info()  { echo -e "${CYAN}info:${NC}  $*"; }
function log.ok()    { echo -e "${GREEN}ok:${NC}    $*"; }
function log.warn()  { echo -e "${YELLOW}warn:${NC}  $*"; }
function log.error() { echo -e "${RED}error:${NC} $*"; }
function log.step()  { echo -e "\n${BLUE}●${NC} $*"; }
