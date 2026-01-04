#!/bin/bash
################################################################################
# Samsung Galaxy A56 5G Longevity Audit Script
# Target: Fedora Workstation 43
# Purpose: Non-destructive device baseline capture for 7-year longevity tracking
# Safety: Read-only ADB commands only
################################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script metadata
SCRIPT_VERSION="1.0.0"
AUDIT_DATE=$(date +%Y-%m-%d_%H-%M-%S)
AUDIT_DIR="A56_Audit_${AUDIT_DATE}"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_step() {
    echo -e "${GREEN}▶${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✖${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

run_adb_safe() {
    local output_file="$1"
    shift
    if adb shell "$@" > "$output_file" 2>&1; then
        print_success "Collected: $(basename "$output_file")"
    else
        print_warning "Partial data: $(basename "$output_file")"
    fi
}

################################################################################
# Pre-flight Checks
################################################################################

preflight_checks() {
    print_header "Pre-flight Checks"
    
    # Check if running on Fedora
    if [ -f /etc/fedora-release ]; then
        print_success "Running on Fedora: $(cat /etc/fedora-release)"
    else
        print_warning "Not running on Fedora - script may still work"
    fi
    
    # Check for ADB
    print_step "Checking for ADB installation..."
    if ! check_command adb; then
        print_error "ADB not found!"
        echo ""
        echo "To install ADB on Fedora 43, run:"
        echo -e "${YELLOW}sudo dnf install android-tools${NC}"
        echo ""
        read -p "Would you like to install it now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_step "Installing android-tools..."
            sudo dnf install -y android-tools
            print_success "ADB installed!"
        else
            print_error "Cannot proceed without ADB. Exiting."
            exit 1
        fi
    else
        print_success "ADB found: $(adb version | head -n1)"
    fi
    
    # Check ADB server
    print_step "Starting ADB server..."
    adb start-server > /dev/null 2>&1
    sleep 1
    
    # Check device connection
    print_step "Checking for connected devices..."
    DEVICE_COUNT=$(adb devices | grep -v "List" | grep "device$" | wc -l)
    
    if [ "$DEVICE_COUNT" -eq 0 ]; then
        print_error "No device detected!"
        echo ""
        echo "Please ensure:"
        echo "  1. USB debugging is enabled on your Galaxy A56 5G"
        echo "  2. Device is connected via USB cable"
        echo "  3. You've accepted the 'Allow USB debugging' prompt on the phone"
        echo ""
        adb devices
        exit 1
    elif [ "$DEVICE_COUNT" -gt 1 ]; then
        print_warning "Multiple devices detected. Using first device."
    fi
    
    print_success "Device connected: $(adb devices | grep device$ | awk '{print $1}')"
    
    # Verify we can execute shell commands
    print_step "Testing ADB shell access..."
    if ! adb shell "echo test" > /dev/null 2>&1; then
        print_error "Cannot execute shell commands. Check USB debugging authorization."
        exit 1
    fi
    print_success "ADB shell access confirmed"
}

################################################################################
# Setup Audit Directory
################################################################################

setup_audit_directory() {
    print_header "Setting Up Audit Directory"
    
    mkdir -p "$AUDIT_DIR"
    print_success "Created: $AUDIT_DIR"
    
    # Create subdirectories
    mkdir -p "$AUDIT_DIR/01_identity"
    mkdir -p "$AUDIT_DIR/02_battery"
    mkdir -p "$AUDIT_DIR/03_storage"
    mkdir -p "$AUDIT_DIR/04_apps"
    mkdir -p "$AUDIT_DIR/05_thermal"
    mkdir -p "$AUDIT_DIR/06_network"
    mkdir -p "$AUDIT_DIR/07_security"
    mkdir -p "$AUDIT_DIR/08_optional"
    
    # Create metadata file
    cat > "$AUDIT_DIR/00_AUDIT_METADATA.txt" <<EOF
Samsung Galaxy A56 5G - Longevity Audit Report
===============================================
Audit Date: $AUDIT_DATE
Script Version: $SCRIPT_VERSION
Fedora Version: $(cat /etc/fedora-release 2>/dev/null || echo "Unknown")
ADB Version: $(adb version | head -n1)

Purpose: Baseline capture for 7-year longevity tracking
Safety: All commands are READ-ONLY and non-destructive

Device Goal:
- Longevity target: 7+ years
- Usage profile: Student (light usage, ~5h/day screen time)
- Primary apps: WhatsApp, Instagram, YouTube, Substack, Banking
- Environment: Hot climate (Indonesia)
- Priority: Battery health preservation > performance

===============================================
EOF
    
    print_success "Metadata file created"
}

################################################################################
# Phase 1: Identity & Update Baseline
################################################################################

phase1_identity() {
    print_header "Phase 1: Identity & Update Baseline"
    
    local OUT_DIR="$AUDIT_DIR/01_identity"
    
    print_step "Collecting device identity..."
    
    # Model & device info
    adb shell getprop ro.product.model > "$OUT_DIR/model.txt"
    adb shell getprop ro.product.device > "$OUT_DIR/device_codename.txt"
    adb shell getprop ro.product.manufacturer > "$OUT_DIR/manufacturer.txt"
    
    # Android & One UI versions
    adb shell getprop ro.build.version.release > "$OUT_DIR/android_version.txt"
    adb shell getprop ro.build.version.sdk > "$OUT_DIR/android_sdk.txt"
    adb shell getprop ro.build.version.oneui > "$OUT_DIR/oneui_version.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/oneui_version.txt"
    
    # Build info
    adb shell getprop ro.build.fingerprint > "$OUT_DIR/build_fingerprint.txt"
    adb shell getprop ro.build.id > "$OUT_DIR/build_id.txt"
    adb shell getprop ro.build.display.id > "$OUT_DIR/build_display_id.txt"
    
    # Security patch
    adb shell getprop ro.build.version.security_patch > "$OUT_DIR/security_patch.txt"
    
    # Kernel version
    adb shell uname -a > "$OUT_DIR/kernel_version.txt"
    
    # CSC (region/carrier config)
    adb shell getprop ro.csc.country_code > "$OUT_DIR/csc_country.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/csc_country.txt"
    adb shell getprop ro.csc.sales_code > "$OUT_DIR/csc_sales_code.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/csc_sales_code.txt"
    
    # Knox version
    adb shell getprop ro.boot.warranty_bit > "$OUT_DIR/knox_warranty_bit.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/knox_warranty_bit.txt"
    adb shell getprop ro.boot.knox_api_level > "$OUT_DIR/knox_api_level.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/knox_api_level.txt"
    
    # Full property dump (comprehensive reference)
    adb shell getprop > "$OUT_DIR/full_properties.txt"
    
    print_success "Phase 1 complete"
}

################################################################################
# Phase 2: Battery & Charging Health
################################################################################

phase2_battery() {
    print_header "Phase 2: Battery & Charging Health"
    
    local OUT_DIR="$AUDIT_DIR/02_battery"
    
    print_step "Collecting battery health data..."
    
    # Current battery state
    run_adb_safe "$OUT_DIR/battery_status.txt" dumpsys battery
    
    # Battery statistics (can be large)
    print_step "Collecting battery stats (may take 10-30 seconds)..."
    run_adb_safe "$OUT_DIR/battery_stats_full.txt" dumpsys batterystats
    
    # Battery stats summary
    run_adb_safe "$OUT_DIR/battery_stats_checkin.txt" dumpsys batterystats --checkin
    
    # Power management & doze
    run_adb_safe "$OUT_DIR/deviceidle.txt" dumpsys deviceidle
    run_adb_safe "$OUT_DIR/power.txt" dumpsys power
    
    # Battery usage stats
    run_adb_safe "$OUT_DIR/battery_usage.txt" dumpsys batterystats --charged
    
    print_success "Phase 2 complete"
    print_warning "Note: Detailed battery health % may require Samsung Members app"
}

################################################################################
# Phase 3: Storage & Filesystem Health
################################################################################

phase3_storage() {
    print_header "Phase 3: Storage & Filesystem Health"
    
    local OUT_DIR="$AUDIT_DIR/03_storage"
    
    print_step "Collecting storage data..."
    
    # Disk free space
    run_adb_safe "$OUT_DIR/disk_free.txt" df -h
    
    # Disk stats
    run_adb_safe "$OUT_DIR/diskstats.txt" dumpsys diskstats
    
    # Storage usage summary
    run_adb_safe "$OUT_DIR/storage_stats.txt" dumpsys storagestats
    
    # Top storage consumers (safe directories only)
    print_step "Analyzing storage usage by directory..."
    adb shell "du -h -d 1 /sdcard/ 2>/dev/null | sort -h" > "$OUT_DIR/sdcard_usage.txt" 2>&1 || print_warning "Could not analyze /sdcard usage"
    adb shell "du -h -d 1 /sdcard/DCIM 2>/dev/null | sort -h" > "$OUT_DIR/dcim_usage.txt" 2>&1 || echo "No DCIM folder yet" > "$OUT_DIR/dcim_usage.txt"
    adb shell "du -h -d 1 /sdcard/Download 2>/dev/null | sort -h" > "$OUT_DIR/download_usage.txt" 2>&1 || echo "No Download folder yet" > "$OUT_DIR/download_usage.txt"
    adb shell "du -h -d 1 /sdcard/WhatsApp 2>/dev/null | sort -h" > "$OUT_DIR/whatsapp_usage.txt" 2>&1 || echo "No WhatsApp folder yet" > "$OUT_DIR/whatsapp_usage.txt"
    
    # Encryption status
    run_adb_safe "$OUT_DIR/encryption_status.txt" getprop ro.crypto.state
    
    print_success "Phase 3 complete"
}

################################################################################
# Phase 4: Apps & Background Behavior
################################################################################

phase4_apps() {
    print_header "Phase 4: Apps & Background Behavior"
    
    local OUT_DIR="$AUDIT_DIR/04_apps"
    
    print_step "Collecting installed apps..."
    
    # All packages
    adb shell pm list packages > "$OUT_DIR/packages_all.txt"
    adb shell pm list packages -s > "$OUT_DIR/packages_system.txt"
    adb shell pm list packages -3 > "$OUT_DIR/packages_user.txt"
    adb shell pm list packages -e > "$OUT_DIR/packages_enabled.txt"
    adb shell pm list packages -d > "$OUT_DIR/packages_disabled.txt"
    
    # Package details for key apps
    print_step "Collecting details for critical apps..."
    for pkg in com.whatsapp com.instagram.android com.google.android.youtube com.google.android.apps.authenticator2; do
        pkg_name=$(echo "$pkg" | sed 's/.*\.//')
        if adb shell pm list packages | grep -q "$pkg"; then
            adb shell dumpsys package "$pkg" > "$OUT_DIR/package_detail_${pkg_name}.txt" 2>&1
            print_success "  - $pkg_name"
        fi
    done
    
    # Device admin apps
    run_adb_safe "$OUT_DIR/device_admin.txt" dumpsys device_policy
    
    # Running services
    run_adb_safe "$OUT_DIR/services_running.txt" dumpsys activity services
    
    # App ops (permissions tracking)
    run_adb_safe "$OUT_DIR/appops.txt" dumpsys appops
    
    # Battery optimization exemptions
    run_adb_safe "$OUT_DIR/deviceidle_whitelist.txt" dumpsys deviceidle whitelist
    
    # Accessibility services (can cause battery drain)
    run_adb_safe "$OUT_DIR/accessibility.txt" dumpsys accessibility
    
    print_success "Phase 4 complete"
}

################################################################################
# Phase 5: Thermal & Performance
################################################################################

phase5_thermal() {
    print_header "Phase 5: Thermal & Performance"
    
    local OUT_DIR="$AUDIT_DIR/05_thermal"
    
    print_step "Collecting thermal data..."
    
    # Thermal service
    run_adb_safe "$OUT_DIR/thermal_service.txt" dumpsys thermalservice
    
    # CPU info
    run_adb_safe "$OUT_DIR/cpuinfo.txt" cat /proc/cpuinfo
    
    # CPU frequency
    adb shell "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq 2>/dev/null" > "$OUT_DIR/cpu_frequencies.txt" 2>&1 || echo "Could not read CPU frequencies" > "$OUT_DIR/cpu_frequencies.txt"
    
    # Current process snapshot (idle state)
    print_step "Taking process snapshot (idle state)..."
    run_adb_safe "$OUT_DIR/top_snapshot_idle.txt" top -b -n 1
    
    # Memory info
    run_adb_safe "$OUT_DIR/meminfo.txt" cat /proc/meminfo
    run_adb_safe "$OUT_DIR/meminfo_summary.txt" dumpsys meminfo --summary
    
    print_success "Phase 5 complete"
}

################################################################################
# Phase 6: Network & Radio Baseline
################################################################################

phase6_network() {
    print_header "Phase 6: Network & Radio Baseline"
    
    local OUT_DIR="$AUDIT_DIR/06_network"
    
    print_step "Collecting network data..."
    
    # Wi-Fi info (sanitize sensitive data in post-processing)
    print_warning "Wi-Fi dump may contain SSIDs - review before sharing"
    run_adb_safe "$OUT_DIR/wifi.txt" dumpsys wifi
    
    # Telephony/cellular info
    print_warning "Telephony dump may contain IMEI - review before sharing"
    run_adb_safe "$OUT_DIR/telephony.txt" dumpsys telephony.registry
    
    # IMS (VoLTE/VoWiFi) status
    run_adb_safe "$OUT_DIR/ims.txt" dumpsys ims
    
    # Network stats
    run_adb_safe "$OUT_DIR/netstats.txt" dumpsys netstats
    
    # Connectivity
    run_adb_safe "$OUT_DIR/connectivity.txt" dumpsys connectivity
    
    # Bluetooth
    run_adb_safe "$OUT_DIR/bluetooth.txt" dumpsys bluetooth_manager
    
    print_success "Phase 6 complete"
}

################################################################################
# Phase 7: Security Posture
################################################################################

phase7_security() {
    print_header "Phase 7: Security Posture"
    
    local OUT_DIR="$AUDIT_DIR/07_security"
    
    print_step "Collecting security configuration..."
    
    # Lock screen settings
    run_adb_safe "$OUT_DIR/lock_settings.txt" dumpsys lock_settings
    
    # Device policy
    run_adb_safe "$OUT_DIR/device_policy.txt" dumpsys device_policy
    
    # Package verifier (Play Protect)
    adb shell getprop persist.sys.package_verifier > "$OUT_DIR/package_verifier_enabled.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/package_verifier_enabled.txt"
    
    # Unknown sources setting
    adb shell settings get global install_non_market_apps > "$OUT_DIR/unknown_sources.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/unknown_sources.txt"
    
    # Find My Device status
    run_adb_safe "$OUT_DIR/find_my_device.txt" dumpsys activity service com.google.android.gms/.mdm.receivers.MdmDeviceAdminReceiver
    
    # SELinux status
    run_adb_safe "$OUT_DIR/selinux_status.txt" getenforce
    
    # Verified boot state
    adb shell getprop ro.boot.verifiedbootstate > "$OUT_DIR/verified_boot_state.txt" 2>/dev/null || echo "N/A" > "$OUT_DIR/verified_boot_state.txt"
    
    print_success "Phase 7 complete"
}

################################################################################
# Phase 8: Optional Deep Snapshot
################################################################################

phase8_optional() {
    print_header "Phase 8: Optional Deep Snapshot"
    
    local OUT_DIR="$AUDIT_DIR/08_optional"
    
    echo ""
    echo "This phase collects a full bugreport (comprehensive system logs)."
    echo "Bugreports can be very large (10-50 MB) and contain detailed system state."
    echo ""
    read -p "Would you like to collect a bugreport? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Collecting bugreport (this may take 1-3 minutes)..."
        adb bugreport "$OUT_DIR/bugreport_${AUDIT_DATE}.zip"
        print_success "Bugreport saved"
    else
        print_step "Skipping bugreport"
        echo "Skipped by user" > "$OUT_DIR/bugreport_skipped.txt"
    fi
}

################################################################################
# Generate Summary Report
################################################################################

generate_summary() {
    print_header "Generating Summary Report"
    
    local SUMMARY_FILE="$AUDIT_DIR/AUDIT_SUMMARY.txt"
    
    cat > "$SUMMARY_FILE" <<EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                  Samsung Galaxy A56 5G - Audit Summary                       ║
╚══════════════════════════════════════════════════════════════════════════════╝

Audit Date: $AUDIT_DATE
Script Version: $SCRIPT_VERSION

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DEVICE IDENTITY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Model:            $(cat "$AUDIT_DIR/01_identity/model.txt" 2>/dev/null || echo "N/A")
Device Codename:  $(cat "$AUDIT_DIR/01_identity/device_codename.txt" 2>/dev/null || echo "N/A")
Manufacturer:     $(cat "$AUDIT_DIR/01_identity/manufacturer.txt" 2>/dev/null || echo "N/A")

SOFTWARE VERSIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Android Version:  $(cat "$AUDIT_DIR/01_identity/android_version.txt" 2>/dev/null || echo "N/A")
One UI Version:   $(cat "$AUDIT_DIR/01_identity/oneui_version.txt" 2>/dev/null || echo "N/A")
Security Patch:   $(cat "$AUDIT_DIR/01_identity/security_patch.txt" 2>/dev/null || echo "N/A")
Build ID:         $(cat "$AUDIT_DIR/01_identity/build_id.txt" 2>/dev/null || echo "N/A")

BATTERY STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    # Extract key battery info if available
    if [ -f "$AUDIT_DIR/02_battery/battery_status.txt" ]; then
        grep -E "level|health|temperature|voltage" "$AUDIT_DIR/02_battery/battery_status.txt" | head -n 10 >> "$SUMMARY_FILE" 2>/dev/null || echo "Battery data collected - see 02_battery/" >> "$SUMMARY_FILE"
    fi
    
    cat >> "$SUMMARY_FILE" <<EOF

STORAGE OVERVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    # Extract storage summary
    if [ -f "$AUDIT_DIR/03_storage/disk_free.txt" ]; then
        grep -E "/data|/sdcard" "$AUDIT_DIR/03_storage/disk_free.txt" >> "$SUMMARY_FILE" 2>/dev/null || echo "Storage data collected - see 03_storage/" >> "$SUMMARY_FILE"
    fi
    
    cat >> "$SUMMARY_FILE" <<EOF

INSTALLED APPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    # Count packages
    if [ -f "$AUDIT_DIR/04_apps/packages_all.txt" ]; then
        echo "Total packages:  $(wc -l < "$AUDIT_DIR/04_apps/packages_all.txt")" >> "$SUMMARY_FILE"
    fi
    if [ -f "$AUDIT_DIR/04_apps/packages_system.txt" ]; then
        echo "System packages: $(wc -l < "$AUDIT_DIR/04_apps/packages_system.txt")" >> "$SUMMARY_FILE"
    fi
    if [ -f "$AUDIT_DIR/04_apps/packages_user.txt" ]; then
        echo "User packages:   $(wc -l < "$AUDIT_DIR/04_apps/packages_user.txt")" >> "$SUMMARY_FILE"
    fi
    
    cat >> "$SUMMARY_FILE" <<EOF

SECURITY STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Knox Warranty Bit: $(cat "$AUDIT_DIR/01_identity/knox_warranty_bit.txt" 2>/dev/null || echo "N/A")
Verified Boot:     $(cat "$AUDIT_DIR/07_security/verified_boot_state.txt" 2>/dev/null || echo "N/A")
SELinux Status:    $(cat "$AUDIT_DIR/07_security/selinux_status.txt" 2>/dev/null || echo "N/A")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IMPORTANT NOTES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. This is a READ-ONLY baseline snapshot - no system changes were made
2. Review files in 06_network/ before sharing (may contain IMEI/SSIDs)
3. For detailed battery health %, check Samsung Members app on the device
4. Store this audit folder safely for future comparison (6-12 month intervals)
5. All data is local - nothing was uploaded anywhere

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Review the summary above
✓ Check individual phase folders for detailed data
✓ Run this audit again in 6-12 months to track changes
✓ Proceed to "Optimization Phase" to configure longevity settings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Audit completed: $AUDIT_DATE

╔══════════════════════════════════════════════════════════════════════════════╗
║  For 7-year longevity: preserve this baseline for future trend analysis     ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF

    print_success "Summary report generated: $SUMMARY_FILE"
}

################################################################################
# Main Execution
################################################################################

main() {
    clear
    
    cat <<'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║              Samsung Galaxy A56 5G - Longevity Audit Script                 ║
║                                                                              ║
║  Purpose: Non-destructive baseline capture for 7-year device preservation   ║
║  Safety:  READ-ONLY commands only - no system modifications                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF

    echo "This script will collect comprehensive device diagnostics."
    echo "Estimated time: 3-5 minutes"
    echo ""
    read -p "Press Enter to begin audit, or Ctrl+C to cancel..."
    echo ""
    
    # Execute all phases
    preflight_checks
    setup_audit_directory
    phase1_identity
    phase2_battery
    phase3_storage
    phase4_apps
    phase5_thermal
    phase6_network
    phase7_security
    phase8_optional
    generate_summary
    
    # Final output
    print_header "Audit Complete!"
    
    echo ""
    echo "📁 Audit data saved to: ${GREEN}${AUDIT_DIR}/${NC}"
    echo ""
    echo "Quick Summary:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "$AUDIT_DIR/AUDIT_SUMMARY.txt" | head -n 50
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo "  1. Review: cat $AUDIT_DIR/AUDIT_SUMMARY.txt"
    echo "  2. Explore: ls -lh $AUDIT_DIR/*/"
    echo "  3. Archive this baseline for future comparison"
    echo ""
    print_success "All done! Device audit baseline captured successfully."
    echo ""
}

# Run main function
main "$@"
