# =============================================================================
# lib/device.sh — ADB Device Discovery & Validation
# =============================================================================

function device.get_all_usb() {
    "$ADB" devices 2>/dev/null \
        | grep -E "^[A-Za-z0-9]+[[:space:]]+device$" \
        | grep -v "^List" \
        | grep -v ":[0-9]\+[[:space:]]" \
        | awk '{print $1}' || true
}

function device.get_model() {
    local serial="$1"
    local brand model
    brand=$("$ADB" -s "$serial" shell getprop ro.product.brand 2>/dev/null \
        | tr -d '[:space:]' || echo "")
    model=$("$ADB" -s "$serial" shell getprop ro.product.model 2>/dev/null \
        | tr -d '\r' | xargs || echo "Unknown")
    echo "${brand} ${model}"
}

function device.get_android_version() {
    local serial="$1"
    "$ADB" -s "$serial" shell getprop ro.build.version.release 2>/dev/null \
        | tr -d '[:space:]' || echo "?"
}

function device.get_wifi_ip() {
    local serial="$1" ip=""
    for iface in wlan0 wlan1 wlan2 wifi0; do
        ip=$("$ADB" -s "$serial" shell ip addr show "$iface" 2>/dev/null \
            | grep "inet " \
            | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
            | head -1 || true)
        [ -n "$ip" ] && echo "$ip" && return 0
    done
    # Fallback: ip route
    ip=$("$ADB" -s "$serial" shell ip route 2>/dev/null \
        | grep "src" \
        | grep -oE 'src [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
        | grep -v "127\." \
        | awk '{print $2}' | head -1 || true)
    [ -n "$ip" ] && echo "$ip" && return 0
    return 1
}

function device.is_reachable() {
    local target="$1"
    "$ADB" -s "$target" get-state 2>/dev/null | grep -q "device"
}

function device.validate_tools() {
    [ ! -x "$ADB" ] && throw 10 \
        "ADB tidak ditemukan di: ${ADB}" \
        "Jalankan: brew install android-platform-tools"
    [ ! -x "$SCRCPY" ] && throw 11 \
        "Scrcpy tidak ditemukan di: ${SCRCPY}" \
        "Jalankan: brew install scrcpy"
}

function device.validate_android() {
    local serial="$1"
    local version major
    version=$(device.get_android_version "$serial")
    [ -z "$version" ] || [ "$version" = "?" ] && throw 31 \
        "Tidak bisa membaca versi Android dari [${serial}]." \
        "Pastikan HP unlock dan sudah authorize koneksi ADB dari Mac."
    major=$(echo "$version" | cut -d. -f1)
    [ "$major" -lt 11 ] 2>/dev/null && throw 32 \
        "Android ${version} tidak support Audio-Only mode." \
        "Mode --no-video butuh minimal Android 11."
    log.ok "Android ${version} — kompatibel ✓"
}
