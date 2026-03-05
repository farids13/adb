# =============================================================================
# commands/help.sh — Tampilkan bantuan CLI
# =============================================================================

function cmd.help() {
    echo -e "\n${BLUE}${BOLD}  Android Connect${NC}  ${DIM}v3.9 — Pro Edition | Persistent Dasbor${NC}\n"
    echo -e "${BOLD}PENGGUNAAN:${NC}"
    echo -e "  ./android ${CYAN}[perintah]${NC} ${DIM}[argumen]${NC}\n"

    echo -e "${BOLD}DASBOR TUI (Default):${NC}"
    echo -e "  ${CYAN}(kosong)${NC}              Membuka Dasbor Konfigurasi Interaktif."
    echo -e "  ${CYAN}mode${NC}                  Loncati pemilihan perangkat langsung ke Dasbor Mode.\n"

    echo -e "${BOLD}KONEKTIVITAS:${NC}"
    echo -e "  ${CYAN}pick${NC}                  Luncurkan Picker Perangkat untuk memilih target."
    echo -e "  ${CYAN}usb${NC}   ${DIM}[nama]${NC}          Paksa koneksi USB (dengan fallback WiFi)."
    echo -e "  ${CYAN}wifi${NC}  ${DIM}[nama]${NC}          Inisialisasi koneksi Wireless ADB."
    echo -e "  ${CYAN}use${NC}   ${DIM}<nama> [mode]${NC}   Hubungkan ke perangkat tersimpan melalui identitas.\n"
 
    echo -e "${BOLD}MANAJEMEN PERANGKAT:${NC}"
    echo -e "  ${CYAN}list${NC}                  Tampilkan semua perangkat aktif dan tersimpan."
    echo -e "  ${CYAN}save${NC}  ${DIM}<nama>${NC}          Simpan perangkat aktif ke dalam registry database."
    echo -e "  ${CYAN}forget${NC} ${DIM}<nama>${NC}         Hapus entri perangkat dari registry."
    echo -e "  ${CYAN}rename${NC} ${DIM}<lama> <baru>${NC}  Ubah identitas (nickname) perangkat di registry.\n"
 
    echo -e "${BOLD}CONTOH:${NC}"
    echo -e "  ${DIM}./android save \"Samsung-S22\"${NC}        # Simpan perangkat saat ini."
    echo -e "  ${DIM}./android use \"Samsung-S22\" wifi${NC}   # Hubungkan ke perangkat via WiFi.\n"

    echo -e "${BOLD}FILES (semua di folder yang sama):${NC}"
    echo -e "  ${DIM}.devices${NC}   Device registry (auto-generated)\n"
}
