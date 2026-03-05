# =============================================================================
# lib/registry.sh — Device Registry CRUD
# Format: SERIAL<TAB>NICKNAME<TAB>LAST_IP
# =============================================================================

function registry.init() {
    if [ ! -f "$DEVICE_REGISTRY" ]; then
        {
            echo "# Android Device Registry"
            echo "# Format: SERIAL<TAB>NICKNAME<TAB>LAST_IP"
        } > "$DEVICE_REGISTRY"
    fi
}

function registry.save() {
    local serial="$1" nickname="$2" ip="${3:-}"
    local tmp; tmp=$(mktemp)
    {
        grep "^#" "$DEVICE_REGISTRY" || true
        grep -v "^#" "$DEVICE_REGISTRY" \
            | grep -v "^${serial}	" \
            | grep -v "	${nickname}	" \
            || true
        printf "%s\t%s\t%s\n" "$serial" "$nickname" "$ip"
    } > "$tmp"
    mv "$tmp" "$DEVICE_REGISTRY"
}

function registry.update_ip() {
    local serial="$1" ip="$2"
    [ -f "$DEVICE_REGISTRY" ] || return 0
    local tmp; tmp=$(mktemp)
    while IFS= read -r line; do
        if echo "$line" | grep -q "^${serial}	"; then
            local nick; nick=$(echo "$line" | awk -F'\t' '{print $2}')
            printf "%s\t%s\t%s\n" "$serial" "$nick" "$ip"
        else
            echo "$line"
        fi
    done < "$DEVICE_REGISTRY" > "$tmp"
    mv "$tmp" "$DEVICE_REGISTRY"
}

# Upsert: update IP jika serial ada, buat entry baru jika belum ada
function registry.upsert_ip() {
    local serial="$1" ip="$2"
    registry.init
    if grep -q "^${serial}	" "$DEVICE_REGISTRY" 2>/dev/null; then
        registry.update_ip "$serial" "$ip"
    else
        # Auto-save dengan serial sebagai nickname sementara
        registry.save "$serial" "$serial" "$ip"
        log.info "Device baru otomatis disimpan ke registry: ${serial}"
        log.info "Ganti nickname: ./android rename \"${serial}\" \"Nama HP Kamu\""
    fi
}

function registry.forget() {
    local query="$1"
    [ -f "$DEVICE_REGISTRY" ] || return 1
    local before after tmp
    before=$(grep -c "^[^#]" "$DEVICE_REGISTRY" 2>/dev/null || echo 0)
    tmp=$(mktemp)
    {
        grep "^#" "$DEVICE_REGISTRY" || true
        grep -v "^#" "$DEVICE_REGISTRY" \
            | grep -v "^${query}	" \
            | grep -v "	${query}	" \
            || true
    } > "$tmp"
    mv "$tmp" "$DEVICE_REGISTRY"
    after=$(grep -c "^[^#]" "$DEVICE_REGISTRY" 2>/dev/null || echo 0)
    [ "$after" -lt "$before" ]
}

function registry.get_ip() {
    local serial="$1"
    [ -f "$DEVICE_REGISTRY" ] || return 1
    grep "^${serial}	" "$DEVICE_REGISTRY" | awk -F'\t' '{print $3}' | head -1
}

function registry.get_nickname() {
    local serial="$1"
    [ -f "$DEVICE_REGISTRY" ] || return 1
    grep "^${serial}	" "$DEVICE_REGISTRY" | awk -F'\t' '{print $2}' | head -1
}

function registry.find_serial() {
    local query="$1"
    [ -f "$DEVICE_REGISTRY" ] || return 1
    local serial
    # Exact nickname match
    serial=$(grep -v "^#" "$DEVICE_REGISTRY" \
        | awk -F'\t' -v q="$query" 'tolower($2)==tolower(q){print $1}' | head -1)
    [ -n "$serial" ] && echo "$serial" && return 0
    # Partial nickname match
    serial=$(grep -v "^#" "$DEVICE_REGISTRY" \
        | awk -F'\t' -v q="$query" 'tolower($2)~tolower(q){print $1}' | head -1)
    [ -n "$serial" ] && echo "$serial" && return 0
    # Direct serial match
    serial=$(grep -v "^#" "$DEVICE_REGISTRY" \
        | awk -F'\t' -v q="$query" '$1==q{print $1}' | head -1)
    [ -n "$serial" ] && echo "$serial" && return 0
    return 1
}

function registry.all() {
    [ -f "$DEVICE_REGISTRY" ] || return 0
    grep -v "^#" "$DEVICE_REGISTRY" | grep -v "^$" || true
}
