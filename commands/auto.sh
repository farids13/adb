# =============================================================================
# commands/auto.sh — Dasbor Utama TUI
# =============================================================================

function cmd.auto() {
    clear
    echo -e "${BLUE}${BOLD}📱 DASBOR KONEKSI ANDROID${NC} ${DIM}v3.9 (Pro Edition)${NC}\n"

    # 1. Pemilihan Perangkat (Smart Picker: Deteksi USB & WiFi Registry Online)
    if [ -z "$SELECTED_SERIAL" ]; then
        picker.select || return 1
    fi

    # 2. Validasi Koneksi Serial
    if [[ "$SELECTED_SERIAL" == *":"* ]]; then
        # Verifikasi apakah IP masih dapat dijangkau
        local ip_only; ip_only=$(echo "$SELECTED_SERIAL" | cut -d: -f1)
        if ! ping -c 1 -W 1 "$ip_only" &>/dev/null; then
            log.warn "Perangkat WiFi ${SELECTED_SERIAL} tidak terdeteksi (Offline)."
            SELECTED_SERIAL=""
            SELECTED_NICKNAME=""
            return 1
        fi
    else
        # Verifikasi koneksi USB fisik
        if ! device.get_all_usb | grep -q "^${SELECTED_SERIAL}$" 2>/dev/null; then
             # Transisi otomatis ke WiFi jika USB terputus
             local last_ip; last_ip=$(registry.get_ip "$SELECTED_SERIAL" || true)
             if [ -n "$last_ip" ] && ping -c 1 -W 1 "$last_ip" &>/dev/null; then
                 log.info "USB terputus, beralih ke alamat IP: ${last_ip}"
                 SELECTED_SERIAL="${last_ip}:5555" 
             else
                 log.warn "Perangkat ${SELECTED_SERIAL} tidak ditemukan."
                 SELECTED_SERIAL=""
                 SELECTED_NICKNAME=""
                 return 1
             fi
        fi
    fi

    # 3. Konfigurasi Mode via Dasbor Interaktif
    if [ -z "$SELECTED_PROFILE_FLAGS" ]; then
        settings.menu || return 1
    fi

    # 4. Inisialisasi Mirroring
    if [[ "$SELECTED_SERIAL" == *":"* ]]; then
        cmd.wifi
    else
        cmd.usb "true"
    fi
}
