# =============================================================================
# commands/list.sh — Tampilkan semua device (live + registry)
# =============================================================================

function cmd.list() {
    echo -e "\n${BLUE}${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║            📱  Android Device Manager                ║${NC}"
    echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════════╝${NC}\n"

    # Live USB devices
    echo -e "${BOLD}🔌 Device USB yang terhubung:${NC}"
    local found_usb=false
    while IFS= read -r serial; do
        [ -z "$serial" ] && continue
        found_usb=true
        local model version nick ip
        model=$(device.get_model "$serial")
        version=$(device.get_android_version "$serial")
        nick=$(registry.get_nickname "$serial" || echo "—")
        ip=$(device.get_wifi_ip "$serial" 2>/dev/null || echo "—")
        echo -e "  ${GREEN}●${NC} ${BOLD}${serial}${NC}"
        echo -e "     Model    : ${model}"
        echo -e "     Android  : ${version}"
        echo -e "     Nickname : ${nick}"
        echo -e "     IP WiFi  : ${ip}\n"
    done < <(device.get_all_usb)
    [ "$found_usb" = "false" ] && echo -e "  ${DIM}Tidak ada device USB yang terhubung${NC}\n"

    # Registry
    echo -e "${BOLD}💾 Device tersimpan di registry:${NC}"
    if [ ! -f "$DEVICE_REGISTRY" ] || ! grep -q "^[^#]" "$DEVICE_REGISTRY" 2>/dev/null; then
        echo -e "  ${DIM}Registry kosong.${NC}"
        echo -e "  ${DIM}Simpan device dengan: ${CYAN}./android save <nama>${NC}\n"
        return
    fi

    while IFS=$'\t' read -r serial nick ip; do
        [[ "$serial" == "#"* ]] && continue
        [ -z "$serial" ] && continue
        local status="${DIM}offline${NC}"
        device.get_all_usb | grep -q "^${serial}$" 2>/dev/null \
            && status="${GREEN}online (USB)${NC}"
        "$ADB" -s "${ip}:${ADB_PORT}" get-state 2>/dev/null | grep -q "device" \
            && status="${CYAN}online (WiFi)${NC}"

        echo -e "  ${BOLD}${nick:-—}${NC}  ${DIM}• ${serial}${NC}"
        echo -e "     Last IP  : ${ip:-—}"
        echo -e "     Status   : ${status}\n"
    done < "$DEVICE_REGISTRY"
}
