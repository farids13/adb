# =============================================================================
# commands/save.sh — Simpan device USB ke registry dengan nickname
# =============================================================================

function cmd.save() {
    local nickname="${1:-}"
    [ -z "$nickname" ] && throw 1 "Nickname tidak boleh kosong." \
        "Gunakan: ./android save <nama>"

    log.step "Menyimpan device sebagai: ${nickname}"
    FORCE_PICK=true
    picker.select

    local model ip
    model=$(device.get_model "$SELECTED_SERIAL")
    ip=$(device.get_wifi_ip "$SELECTED_SERIAL" 2>/dev/null || echo "")

    registry.save "$SELECTED_SERIAL" "$nickname" "$ip"

    echo -e "\n${GREEN}${BOLD}  ✅ Device disimpan!${NC}"
    echo -e "  Nickname : ${BOLD}${nickname}${NC}"
    echo -e "  Model    : ${model}"
    echo -e "  Serial   : ${SELECTED_SERIAL}"
    echo -e "  IP WiFi  : ${ip:-—}\n"
    echo -e "  Gunakan: ${CYAN}./android use \"${nickname}\"${NC}\n"
}
