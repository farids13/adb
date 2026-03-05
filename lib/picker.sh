# =============================================================================
# lib/picker.sh — Smart Interactive Device Picker
# Sets globals: SELECTED_SERIAL, SELECTED_NICKNAME
# =============================================================================

function picker.select() {
    local serials=() labels=() ips=()
    local is_wifi=()

    # 1. SCAN USB (Primary)
    while IFS= read -r serial; do
        [ -z "$serial" ] && continue
        local model; model=$(device.get_model "$serial" 2>/dev/null || echo "Unknown")
        local nick; nick=$(registry.get_nickname "$serial" || true)
        
        local label
        if [ -n "$nick" ]; then
            label="${BOLD}[${nick}]${NC}  ${model}  ${GREEN}(USB)${NC}"
        else
            label="${model}  ${GREEN}(USB)${NC} ${DIM}| ${serial}${NC}"
        fi
        
        serials+=("$serial")
        labels+=("$label")
        ips+=("")
        is_wifi+=("false")
    done < <(device.get_all_usb)

    # 2. SCAN REGISTRY WiFi (Secondary) - Hanya jika USB tidak dicolok
    if [ ${#serials[@]} -eq 0 ]; then
        log.info "Mencari device di registry WiFi..."
        while IFS=$'\t' read -r r_serial r_nick r_ip; do
            [ -z "$r_ip" ] && continue
            
            # Cek apakah device online di WiFi (Ping cepat 1s)
            if ping -c 1 -W 1 "$r_ip" &>/dev/null; then
                local label="${BOLD}[${r_nick}]${NC}  ${CYAN}(WiFi)${NC} ${DIM}| ${r_ip}${NC}"
                
                serials+=("${r_ip}:5555") # Target WiFi
                labels+=("$label")
                ips+=("$r_ip")
                is_wifi+=("true")
            fi
        done < <(registry.all)
    fi

    # 3. Handle 0 Device
    if [ ${#serials[@]} -eq 0 ]; then
        log.warn "Menunggu device tersambung (USB/WiFi)..."
        return 1
    fi

    # 4. Auto-pilih jika hanya 1 device (Pintar!)
    if [ ${#serials[@]} -eq 1 ] && [ "$FORCE_PICK" = "false" ]; then
        SELECTED_SERIAL="${serials[0]}"
        if [ "${is_wifi[0]}" = "true" ]; then
             local ip_val="${ips[0]}"
             local real_serial; real_serial=$(grep "$ip_val" "$DEVICE_REGISTRY" | awk -F'\t' '{print $1}' | head -1 || true)
             SELECTED_NICKNAME=$(registry.get_nickname "$real_serial" || true)
        else
             SELECTED_NICKNAME=$(registry.get_nickname "$SELECTED_SERIAL" || true)
        fi
        
        log.ok "Auto-pick: ${SELECTED_NICKNAME:-Device} ${DIM}(${SELECTED_SERIAL})${NC}"
        return 0
    fi

    # 5. UI Menu Picker (Clean & Minimalist)
    echo -e "\n${BLUE}● Pilih Target Connection${NC}"
    local i=1
    for label in "${labels[@]}"; do
        echo -e "  ${BOLD}[${i}]${NC}  ${label}"
        i=$((i + 1))
    done
    echo ""

    local choice
    while true; do
        printf "  Opsi [1-%d]: " "${#serials[@]}"
        read -r choice </dev/tty
        [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#serials[@]}" ] && break
        echo -e "  ${RED}Salah.${NC}"
    done

    local idx=$((choice - 1))
    SELECTED_SERIAL="${serials[$idx]}"
    
    # Update status nickname
    if [ "${is_wifi[$idx]}" = "true" ]; then
         local ip_val="${ips[$idx]}"
         local r_ser; r_ser=$(grep "$ip_val" "$DEVICE_REGISTRY" | awk -F'\t' '{print $1}' | head -1 || true)
         SELECTED_NICKNAME=$(registry.get_nickname "$r_ser" || true)
    else
         SELECTED_NICKNAME=$(registry.get_nickname "$SELECTED_SERIAL" || true)
    fi
    
    log.ok "Selected: ${SELECTED_NICKNAME:-Device} ${DIM}(${SELECTED_SERIAL})${NC}"
}
