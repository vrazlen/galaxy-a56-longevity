#!/usr/bin/env bash
set -euo pipefail

SCRIPT_VERSION="2.0.0"
DEVICE_MODEL="SM-A566B"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
AUDIT_DIR="A56_Audit_v2_${TIMESTAMP}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_status() { echo -e "${BLUE}▶${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✖${NC} $1"; }

safe_collect() {
    local cmd="$1"
    local output_file="$2"
    local description="$3"
    
    if timeout 30 adb shell "$cmd" > "$output_file" 2>&1; then
        if [[ -s "$output_file" ]]; then
            print_success "Collected: $(basename "$output_file")"
        else
            print_warning "Empty output: $(basename "$output_file")"
        fi
    else
        echo "Command failed or timed out: $cmd" > "$output_file"
        print_warning "Failed: $description"
    fi
}

check_adb_connection() {
    print_header "Pre-flight Check"
    
    if ! command -v adb &> /dev/null; then
        print_error "ADB not found. Run: sudo dnf install android-tools"
        exit 1
    fi
    print_success "ADB installed"
    
    adb start-server 2>/dev/null || true
    
    local device_count
    device_count=$(adb devices | grep -c "device$" || echo "0")
    
    if [[ "$device_count" -eq 0 ]]; then
        print_error "No device connected. Connect phone with USB debugging enabled."
        exit 1
    fi
    print_success "Device connected"
    
    if ! adb shell echo "ok" &>/dev/null; then
        print_error "ADB shell access denied. Accept the prompt on your phone."
        exit 1
    fi
    print_success "ADB shell access confirmed"
}

setup_directories() {
    print_header "Setting Up Audit v2 Directory"
    
    mkdir -p "${AUDIT_DIR}"/{01_hardware_sensors,02_display_graphics,03_audio,04_camera,05_thermal_extended,06_storage_fixed,07_radio_extended,08_privacy_baseline,09_samsung_checklist}
    
    cat > "${AUDIT_DIR}/metadata.txt" << EOF
Audit Version: ${SCRIPT_VERSION}
Audit Type: v2 (10/10 Ground Data)
Device Model: ${DEVICE_MODEL}
Timestamp: ${TIMESTAMP}
Purpose: Extended hardware/sensor/display/audio baseline for 7-year longevity tracking
Complements: A56_Audit_2026-01-04_20-27-17 (v1 baseline)
EOF
    
    print_success "Created: ${AUDIT_DIR}"
}

collect_hardware_sensors() {
    print_header "Phase 1: Hardware & Sensors"
    local dir="${AUDIT_DIR}/01_hardware_sensors"
    
    print_status "Collecting input devices inventory..."
    safe_collect "getevent -pl" "${dir}/input_devices.txt" "input devices"
    
    print_status "Collecting sensor service data..."
    safe_collect "dumpsys sensorservice" "${dir}/sensorservice.txt" "sensor service"
    
    print_status "Collecting input configuration..."
    safe_collect "dumpsys input" "${dir}/input_config.txt" "input config"
    
    print_status "Collecting vibrator service..."
    safe_collect "dumpsys vibrator" "${dir}/vibrator.txt" "vibrator"
    
    print_status "Collecting fingerprint service..."
    safe_collect "dumpsys fingerprint" "${dir}/fingerprint.txt" "fingerprint"
    
    print_status "Collecting USB state..."
    safe_collect "dumpsys usb" "${dir}/usb.txt" "usb"
    
    print_success "Phase 1 complete"
}

collect_display_graphics() {
    print_header "Phase 2: Display & Graphics"
    local dir="${AUDIT_DIR}/02_display_graphics"
    
    print_status "Collecting display service..."
    safe_collect "dumpsys display" "${dir}/display_service.txt" "display service"
    
    print_status "Collecting SurfaceFlinger..."
    safe_collect "dumpsys SurfaceFlinger" "${dir}/surfaceflinger.txt" "SurfaceFlinger"
    
    print_status "Collecting window manager size..."
    safe_collect "wm size" "${dir}/wm_size.txt" "window size"
    
    print_status "Collecting window manager density..."
    safe_collect "wm density" "${dir}/wm_density.txt" "window density"
    
    print_status "Collecting graphics stats..."
    safe_collect "dumpsys gfxinfo" "${dir}/gfxinfo.txt" "graphics info"
    
    print_status "Collecting GPU info..."
    safe_collect "dumpsys gpu" "${dir}/gpu.txt" "GPU"
    
    print_status "Collecting settings display values..."
    {
        echo "screen_brightness: $(adb shell settings get system screen_brightness 2>/dev/null || echo 'N/A')"
        echo "screen_brightness_mode: $(adb shell settings get system screen_brightness_mode 2>/dev/null || echo 'N/A')"
        echo "screen_off_timeout: $(adb shell settings get system screen_off_timeout 2>/dev/null || echo 'N/A')"
        echo "peak_refresh_rate: $(adb shell settings get system peak_refresh_rate 2>/dev/null || echo 'N/A')"
        echo "min_refresh_rate: $(adb shell settings get system min_refresh_rate 2>/dev/null || echo 'N/A')"
    } > "${dir}/display_settings.txt"
    print_success "Collected: display_settings.txt"
    
    print_success "Phase 2 complete"
}

collect_audio() {
    print_header "Phase 3: Audio"
    local dir="${AUDIT_DIR}/03_audio"
    
    print_status "Collecting audio service..."
    safe_collect "dumpsys audio" "${dir}/audio_service.txt" "audio service"
    
    print_status "Collecting audio flinger..."
    safe_collect "dumpsys media.audio_flinger" "${dir}/audio_flinger.txt" "audio flinger"
    
    print_status "Collecting audio policy..."
    safe_collect "dumpsys media.audio_policy" "${dir}/audio_policy.txt" "audio policy"
    
    print_status "Collecting media session..."
    safe_collect "dumpsys media_session" "${dir}/media_session.txt" "media session"
    
    print_success "Phase 3 complete"
}

collect_camera() {
    print_header "Phase 4: Camera Inventory"
    local dir="${AUDIT_DIR}/04_camera"
    
    print_status "Collecting camera service (method 1)..."
    safe_collect "dumpsys media.camera" "${dir}/camera_media.txt" "camera media"
    
    print_status "Collecting camera service (method 2)..."
    safe_collect "dumpsys camera" "${dir}/camera_service.txt" "camera service"
    
    print_status "Collecting cameraserver..."
    safe_collect "dumpsys cameraservice" "${dir}/cameraservice.txt" "cameraservice"
    
    print_success "Phase 4 complete"
}

collect_thermal_extended() {
    print_header "Phase 5: Thermal & Hardware Properties (Extended)"
    local dir="${AUDIT_DIR}/05_thermal_extended"
    
    print_status "Collecting thermal service..."
    safe_collect "dumpsys thermalservice" "${dir}/thermal_service.txt" "thermal service"
    
    print_status "Collecting hardware properties..."
    safe_collect "dumpsys hardware_properties" "${dir}/hardware_properties.txt" "hardware properties"
    
    print_status "Reading thermal zone temperatures..."
    {
        for tz in /sys/class/thermal/thermal_zone*; do
            tz_name=$(basename "$tz")
            type_val=$(adb shell "cat ${tz}/type 2>/dev/null" || echo "unknown")
            temp_val=$(adb shell "cat ${tz}/temp 2>/dev/null" || echo "N/A")
            echo "${tz_name}: type=${type_val}, temp=${temp_val}"
        done
    } > "${dir}/thermal_zones.txt" 2>/dev/null || echo "Could not read thermal zones" > "${dir}/thermal_zones.txt"
    print_success "Collected: thermal_zones.txt"
    
    print_status "Collecting CPU scaling governors..."
    adb shell "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null" > "${dir}/cpu_governors.txt" || echo "N/A" > "${dir}/cpu_governors.txt"
    print_success "Collected: cpu_governors.txt"
    
    print_status "Collecting CPU frequencies..."
    {
        echo "=== Current frequencies ==="
        adb shell "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq 2>/dev/null" || echo "N/A"
        echo ""
        echo "=== Min frequencies ==="
        adb shell "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq 2>/dev/null" || echo "N/A"
        echo ""
        echo "=== Max frequencies ==="
        adb shell "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq 2>/dev/null" || echo "N/A"
    } > "${dir}/cpu_freq_details.txt"
    print_success "Collected: cpu_freq_details.txt"
    
    print_success "Phase 5 complete"
}

collect_storage_fixed() {
    print_header "Phase 6: Storage (Fixed for Scoped Storage)"
    local dir="${AUDIT_DIR}/06_storage_fixed"
    
    print_status "Collecting disk free (all mount points)..."
    safe_collect "df -h" "${dir}/df_all.txt" "disk free"
    
    print_status "Collecting disk stats..."
    safe_collect "dumpsys diskstats" "${dir}/diskstats.txt" "disk stats"
    
    print_status "Trying storagedump..."
    safe_collect "cmd storagedump" "${dir}/storagedump.txt" "storage dump"
    
    print_status "Collecting package sizes (top 50 by size)..."
    {
        echo "=== User-installed packages with sizes ==="
        adb shell "pm list packages -3" | cut -d: -f2 | while read -r pkg; do
            size=$(adb shell "dumpsys package $pkg 2>/dev/null" | grep -E "codePath|dataDir|codeSize|dataSize" | head -4)
            if [[ -n "$size" ]]; then
                echo "--- $pkg ---"
                echo "$size"
                echo ""
            fi
        done
    } > "${dir}/package_sizes.txt" 2>/dev/null
    print_success "Collected: package_sizes.txt"
    
    print_status "Collecting storage volumes..."
    safe_collect "sm list-volumes" "${dir}/storage_volumes.txt" "storage volumes"
    
    print_status "Collecting mount info..."
    safe_collect "mount" "${dir}/mount_info.txt" "mount info"
    
    print_status "Analyzing accessible storage paths..."
    {
        echo "=== /sdcard top-level ==="
        adb shell "ls -la /sdcard/ 2>/dev/null" || echo "Cannot list /sdcard"
        echo ""
        echo "=== /sdcard/Android/media (WhatsApp location) ==="
        adb shell "ls -la /sdcard/Android/media/ 2>/dev/null" || echo "Cannot list Android/media"
        echo ""
        echo "=== /sdcard/DCIM ==="
        adb shell "ls -la /sdcard/DCIM/ 2>/dev/null" || echo "Cannot list DCIM"
        echo ""
        echo "=== /sdcard/Download ==="
        adb shell "ls -la /sdcard/Download/ 2>/dev/null" || echo "Cannot list Download"
    } > "${dir}/storage_paths.txt"
    print_success "Collected: storage_paths.txt"
    
    print_success "Phase 6 complete"
}

collect_radio_extended() {
    print_header "Phase 7: Radio & Connectivity (Extended)"
    local dir="${AUDIT_DIR}/07_radio_extended"
    
    print_status "Collecting net policy..."
    safe_collect "dumpsys netpolicy" "${dir}/netpolicy.txt" "net policy"
    
    print_status "Collecting NFC..."
    safe_collect "dumpsys nfc" "${dir}/nfc.txt" "NFC"
    
    print_status "Collecting connectivity..."
    safe_collect "dumpsys connectivity" "${dir}/connectivity.txt" "connectivity"
    
    print_status "Collecting network stats..."
    safe_collect "dumpsys netstats" "${dir}/netstats.txt" "network stats"
    
    print_status "Collecting carrier config..."
    safe_collect "dumpsys carrier_config" "${dir}/carrier_config.txt" "carrier config"
    
    print_status "Collecting SIM state..."
    {
        echo "sim_state: $(adb shell getprop gsm.sim.state 2>/dev/null || echo 'N/A')"
        echo "operator: $(adb shell getprop gsm.operator.alpha 2>/dev/null || echo 'N/A')"
        echo "network_type: $(adb shell getprop gsm.network.type 2>/dev/null || echo 'N/A')"
        echo "data_state: $(adb shell dumpsys telephony.registry 2>/dev/null | grep -i "mDataConnectionState" | head -1 || echo 'N/A')"
    } > "${dir}/sim_state.txt"
    print_success "Collected: sim_state.txt"
    
    print_status "Collecting airplane mode state..."
    adb shell "settings get global airplane_mode_on" > "${dir}/airplane_mode.txt" 2>/dev/null
    print_success "Collected: airplane_mode.txt"
    
    print_success "Phase 7 complete"
}

collect_privacy_baseline() {
    print_header "Phase 8: Privacy Baseline (Settings State)"
    local dir="${AUDIT_DIR}/08_privacy_baseline"
    
    print_status "Collecting secure settings (non-sensitive subset)..."
    {
        echo "=== Lock screen / security settings ==="
        echo "lock_screen_lock_after_timeout: $(adb shell settings get secure lock_screen_lock_after_timeout 2>/dev/null || echo 'N/A')"
        echo "lockscreen_show_notifications: $(adb shell settings get secure lock_screen_show_notifications 2>/dev/null || echo 'N/A')"
        echo "install_non_market_apps: $(adb shell settings get secure install_non_market_apps 2>/dev/null || echo 'N/A')"
        echo ""
        echo "=== Backup settings ==="
        echo "backup_enabled: $(adb shell settings get secure backup_enabled 2>/dev/null || echo 'N/A')"
        echo "backup_transport: $(adb shell settings get secure backup_transport 2>/dev/null || echo 'N/A')"
        echo ""
        echo "=== Location settings ==="
        echo "location_mode: $(adb shell settings get secure location_mode 2>/dev/null || echo 'N/A')"
        echo "location_providers_allowed: $(adb shell settings get secure location_providers_allowed 2>/dev/null || echo 'N/A')"
    } > "${dir}/secure_settings.txt"
    print_success "Collected: secure_settings.txt"
    
    print_status "Collecting global settings (non-sensitive subset)..."
    {
        echo "=== Battery / power settings ==="
        echo "low_power: $(adb shell settings get global low_power 2>/dev/null || echo 'N/A')"
        echo "low_power_trigger_level: $(adb shell settings get global low_power_trigger_level 2>/dev/null || echo 'N/A')"
        echo "always_on_display: $(adb shell settings get global always_on_display 2>/dev/null || echo 'N/A')"
        echo ""
        echo "=== Data / sync settings ==="
        echo "auto_sync: $(adb shell settings get global auto_sync 2>/dev/null || echo 'N/A')"
        echo "mobile_data: $(adb shell settings get global mobile_data 2>/dev/null || echo 'N/A')"
        echo "data_roaming: $(adb shell settings get global data_roaming 2>/dev/null || echo 'N/A')"
        echo ""
        echo "=== Update settings ==="
        echo "package_verifier_enable: $(adb shell settings get global package_verifier_enable 2>/dev/null || echo 'N/A')"
        echo "verifier_verify_adb_installs: $(adb shell settings get global verifier_verify_adb_installs 2>/dev/null || echo 'N/A')"
    } > "${dir}/global_settings.txt"
    print_success "Collected: global_settings.txt"
    
    print_status "Collecting system settings (non-sensitive subset)..."
    {
        echo "=== Display settings ==="
        echo "screen_brightness: $(adb shell settings get system screen_brightness 2>/dev/null || echo 'N/A')"
        echo "screen_brightness_mode: $(adb shell settings get system screen_brightness_mode 2>/dev/null || echo 'N/A')"
        echo "screen_off_timeout: $(adb shell settings get system screen_off_timeout 2>/dev/null || echo 'N/A')"
        echo ""
        echo "=== Sound settings ==="
        echo "volume_ring: $(adb shell settings get system volume_ring 2>/dev/null || echo 'N/A')"
        echo "volume_notification: $(adb shell settings get system volume_notification 2>/dev/null || echo 'N/A')"
        echo "vibrate_when_ringing: $(adb shell settings get system vibrate_when_ringing 2>/dev/null || echo 'N/A')"
        echo ""
        echo "=== Accessibility ==="
        echo "font_scale: $(adb shell settings get system font_scale 2>/dev/null || echo 'N/A')"
    } > "${dir}/system_settings.txt"
    print_success "Collected: system_settings.txt"
    
    print_status "Collecting battery optimization whitelist..."
    safe_collect "dumpsys deviceidle whitelist" "${dir}/battery_whitelist.txt" "battery whitelist"
    
    print_status "Collecting app standby buckets..."
    safe_collect "dumpsys usagestats appstandby" "${dir}/app_standby.txt" "app standby"
    
    print_success "Phase 8 complete"
}

generate_samsung_checklist() {
    print_header "Phase 9: Samsung On-Device Diagnostics Checklist"
    local dir="${AUDIT_DIR}/09_samsung_checklist"
    
    cat > "${dir}/SAMSUNG_DIAGNOSTICS_CHECKLIST.md" << 'EOF'
# Samsung On-Device Diagnostics Checklist
## Complete these steps manually on your Galaxy A56 5G

### 1. Battery Health (Samsung Members)
- [ ] Open **Samsung Members** app
- [ ] Go to **Get help** → **Interactive checks** → **Battery**
- [ ] Run the battery diagnostic
- [ ] Record result: ____________________
- [ ] Screenshot the battery health/status page

### 2. Device Care Full Diagnostics
- [ ] Open **Settings** → **Battery and device care**
- [ ] Tap **Diagnostics** (or find via Samsung Members)
- [ ] Run **ALL** tests:
  - [ ] Touchscreen: Pass / Fail
  - [ ] Multi-touch: Pass / Fail
  - [ ] Sensors (accelerometer, gyro, etc.): Pass / Fail
  - [ ] Speaker: Pass / Fail
  - [ ] Microphone: Pass / Fail
  - [ ] Vibration: Pass / Fail
  - [ ] Fingerprint: Pass / Fail
  - [ ] Charging: Pass / Fail
  - [ ] Camera (front): Pass / Fail
  - [ ] Camera (rear): Pass / Fail
- [ ] Screenshot each result or the summary

### 3. Battery Protection Settings
- [ ] Open **Settings** → **Battery and device care** → **Battery**
- [ ] Check **Battery protection** setting:
  - Current mode: Maximum / Adaptive / Basic / Off
  - Record: ____________________
- [ ] Check **Fast charging** toggle: On / Off
- [ ] Check **Super fast charging** toggle: On / Off
- [ ] Screenshot these settings

### 4. Display Check
- [ ] Use a dead pixel test app or website (fullscreen red/green/blue/white/black)
- [ ] Any dead/stuck pixels? Yes / No
- [ ] Location if yes: ____________________
- [ ] Brightness slider works full range? Yes / No
- [ ] Auto-brightness works? Yes / No
- [ ] 120Hz smoothness noticeable? Yes / No

### 5. Thermal Baseline (Real-World Test)
- [ ] Note ambient temperature: ____ °C
- [ ] Play YouTube 1080p for 10 minutes
- [ ] Then scroll Instagram for 10 minutes
- [ ] Phone temperature after (touch feel): Cool / Warm / Hot
- [ ] If using a temp app, record: ____ °C

### 6. Security Posture Confirmation
- [ ] Screen lock enabled? PIN + Fingerprint / Other: ____
- [ ] Samsung Find My Mobile: On / Off
- [ ] Google Find My Device: On / Off
- [ ] Samsung Pass configured? Yes / No
- [ ] Google Authenticator installed? Yes / No
- [ ] Biometric unlock for sensitive apps? Yes / No

### 7. Backup Configuration
- [ ] Google backup enabled? Yes / No
- [ ] Samsung Cloud backup enabled? Yes / No
- [ ] Smart Switch backup done? Yes / No / Not yet
- [ ] 2FA recovery codes saved offline? Yes / No

### 8. Update Settings
- [ ] Auto-download updates over Wi-Fi? Yes / No
- [ ] Current security patch level: ____________________
- [ ] One UI version: ____________________

---

## After completing this checklist:
1. Save this file with your answers filled in
2. Store screenshots in the same audit folder
3. This completes your "10/10 ground data" baseline

Date completed: ____________________
EOF
    
    print_success "Generated: SAMSUNG_DIAGNOSTICS_CHECKLIST.md"
    print_warning "Complete this checklist manually on your phone"
    print_success "Phase 9 complete"
}

generate_v2_summary() {
    print_header "Generating Audit v2 Summary"
    
    local summary_file="${AUDIT_DIR}/AUDIT_V2_SUMMARY.txt"
    
    cat > "$summary_file" << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║              Samsung Galaxy A56 5G - Audit v2 Summary (10/10)                ║
╚══════════════════════════════════════════════════════════════════════════════╝

Audit Date: ${TIMESTAMP}
Script Version: ${SCRIPT_VERSION}
Audit Type: Extended Hardware/Sensor/Display/Audio Baseline

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

COMPLEMENTS V1 AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This v2 audit extends: A56_Audit_2026-01-04_20-27-17
Together they form your complete 10/10 ground data baseline.

PHASES COLLECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1: Hardware & Sensors
  - Input devices, sensor service, vibrator, fingerprint, USB

Phase 2: Display & Graphics
  - Display service, SurfaceFlinger, window manager, GPU, display settings

Phase 3: Audio
  - Audio service, audio flinger, audio policy, media session

Phase 4: Camera
  - Camera service inventory (no photos taken)

Phase 5: Thermal (Extended)
  - Thermal zones, CPU governors, frequency ranges

Phase 6: Storage (Fixed)
  - Disk stats, storage volumes, package sizes, accessible paths

Phase 7: Radio (Extended)
  - Net policy, NFC, carrier config, SIM state

Phase 8: Privacy Baseline
  - Non-sensitive settings state (battery, sync, display, security toggles)

Phase 9: Samsung Checklist
  - Manual on-device diagnostics checklist generated

EOF

    # Append sensor count if available
    if [[ -f "${AUDIT_DIR}/01_hardware_sensors/sensorservice.txt" ]]; then
        local sensor_count
        sensor_count=$(grep -c "handle=" "${AUDIT_DIR}/01_hardware_sensors/sensorservice.txt" 2>/dev/null || echo "N/A")
        echo "SENSOR INVENTORY" >> "$summary_file"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$summary_file"
        echo "Total sensors detected: ${sensor_count}" >> "$summary_file"
        echo "" >> "$summary_file"
    fi
    
    # Append display info if available
    if [[ -f "${AUDIT_DIR}/02_display_graphics/display_settings.txt" ]]; then
        echo "DISPLAY SETTINGS" >> "$summary_file"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$summary_file"
        cat "${AUDIT_DIR}/02_display_graphics/display_settings.txt" >> "$summary_file"
        echo "" >> "$summary_file"
    fi
    
    # Append key privacy baseline settings
    if [[ -f "${AUDIT_DIR}/08_privacy_baseline/global_settings.txt" ]]; then
        echo "KEY LONGEVITY SETTINGS" >> "$summary_file"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$summary_file"
        cat "${AUDIT_DIR}/08_privacy_baseline/global_settings.txt" >> "$summary_file"
        echo "" >> "$summary_file"
    fi
    
    cat >> "$summary_file" << 'EOF'

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Complete the Samsung checklist: 09_samsung_checklist/SAMSUNG_DIAGNOSTICS_CHECKLIST.md
2. Store both audit folders (v1 + v2) together safely
3. Proceed to "Optimization Phase" for longevity tuning
4. Re-run audits in 6-12 months to track changes

PRIVACY NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This audit is for YOUR LOCAL TRACKING ONLY (Option A).
- No content (photos/messages) was collected
- Some files may contain device identifiers (keep private)
- Do not share raw dumps publicly without redaction

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

╔══════════════════════════════════════════════════════════════════════════════╗
║  Combined v1 + v2 = 10/10 Ground Data for 7-Year Longevity Tracking          ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF

    print_success "Summary generated: AUDIT_V2_SUMMARY.txt"
}

main() {
    echo -e "\n${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║                                                                              ║${NC}"
    echo -e "${BOLD}║          Samsung Galaxy A56 5G - Audit v2 (10/10 Ground Data)               ║${NC}"
    echo -e "${BOLD}║                                                                              ║${NC}"
    echo -e "${BOLD}║  Purpose: Extended hardware/sensor/display/audio baseline                   ║${NC}"
    echo -e "${BOLD}║  Safety:  READ-ONLY commands only - no system modifications                 ║${NC}"
    echo -e "${BOLD}║                                                                              ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "This script extends your v1 audit with hardware/sensor/display/audio data."
    echo "Estimated time: 2-4 minutes"
    echo ""
    read -rp "Press Enter to begin, or Ctrl+C to cancel..."
    
    check_adb_connection
    setup_directories
    
    collect_hardware_sensors
    collect_display_graphics
    collect_audio
    collect_camera
    collect_thermal_extended
    collect_storage_fixed
    collect_radio_extended
    collect_privacy_baseline
    generate_samsung_checklist
    
    generate_v2_summary
    
    print_header "Audit v2 Complete!"
    echo ""
    echo -e "📁 Audit data saved to: ${GREEN}${AUDIT_DIR}/${NC}"
    echo ""
    echo "Quick Summary:"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    cat "${AUDIT_DIR}/AUDIT_V2_SUMMARY.txt" | head -50
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Complete: ${AUDIT_DIR}/09_samsung_checklist/SAMSUNG_DIAGNOSTICS_CHECKLIST.md"
    echo "  2. Review:   cat ${AUDIT_DIR}/AUDIT_V2_SUMMARY.txt"
    echo "  3. Archive:  Store v1 + v2 folders together"
    echo ""
    echo -e "${GREEN}✓${NC} All done! Your 10/10 ground data baseline is ready."
}

main "$@"
