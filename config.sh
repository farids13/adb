# =============================================================================
# config.sh — Global Configuration
# Edit nilai di sini sesuai kebutuhan
# =============================================================================

# ── ADB & Scrcpy ─────────────────────────────────────────────────────────────
ADB="/opt/homebrew/bin/adb"
SCRCPY="/opt/homebrew/bin/scrcpy"

# ── ADB Wireless ─────────────────────────────────────────────────────────────
ADB_PORT=5555

# ── Scrcpy Settings ──────────────────────────────────────────────────────────
SCRCPY_AUDIO_BITRATE="128K"    # Pilihan: 64K | 128K | 256K | 320K

# ── Timeouts (detik) ─────────────────────────────────────────────────────────
CONNECT_TIMEOUT=10
USB_WAIT_TIMEOUT=15
WIFI_FALLBACK_DELAY=3

# ── Storage (SCRIPT_DIR diset oleh entry point) ───────────────────────────────
DEVICE_REGISTRY="${SCRIPT_DIR}/.devices"
