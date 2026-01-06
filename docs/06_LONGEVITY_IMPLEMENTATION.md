# Galaxy A56 5G: 7-Year Longevity Implementation Plan

**Version:** 1.0.0  
**Based On:** Research synthesis (Battery University, XDA, Samsung docs, FOSS communities)  
**Target:** Maximize device lifespan in Jakarta climate (~40°C ambient)

---

## Executive Summary

Research confirms your current setup (80% cap, fast charging off, LTE preferred) is aligned with longevity goals. The dominant remaining risk is **heat during charging** (you reported ~42°C). This plan provides research-backed thresholds and actionable tasks.

### Key Research Findings

| Factor | Threshold | Your Status | Action |
|--------|-----------|-------------|--------|
| Charging temp | <35°C ideal, >40°C accelerates aging | ~42°C reported | **Reduce** |
| SoC range | 20-80% optimal | 80% cap ✓ | Maintain |
| Fast charging | OK to 80%, never to 100% | Disabled ✓ | Maintain |
| 5G vs LTE | 5G uses 30-40% more power | LTE preferred ✓ | Maintain |

**Bottom line:** Every 10°C above 25°C doubles battery aging rate. At 42°C while charging, you're in the "accelerated degradation" zone. Fixing this is the highest-ROI change.

---

## Phase 1: Thermal Protocol (Highest Priority)

### Scientific Basis
- **<30°C**: Minimal degradation
- **30-35°C**: Moderate degradation  
- **35-40°C**: Significant degradation
- **>40°C**: Severe degradation (35% capacity loss possible in 3 months at 45°C + high SoC)
- **Combined effect**: 100% SoC + 40°C = 35% capacity loss in 12 months vs 40% SoC + 25°C = 2% loss

### Exynos 1580 Thermal Throttling Zones
| Temp Range | Throttling Level | Meaning |
|------------|------------------|---------|
| 38-42°C | Light | Performance slightly reduced |
| 42-45°C | Moderate | Noticeable slowdown |
| 45-48°C | Heavy | Significant throttling |
| >48°C | Emergency | Force shutdown risk |

### Daily Charging Rules

1. **Before plugging in**: If phone feels warm, wait 10-15 minutes
2. **During charging**: Keep on hard surface (tile/metal tray), elevate one edge for airflow
3. **If available**: Point a small fan at the phone while charging
4. **Never combine**: Charging + hotspot + navigation + direct sunlight
5. **Pause rule**: If phone feels hot during charging, unplug for 15 minutes

### Charging Schedule Optimization
Since you charge around noon (hottest time), consider:
- **Shorter sessions**: 20-30 min top-ups with rest periods
- **If possible**: Shift to early morning (6-8 AM) or late evening (8-10 PM)

---

## Phase 2: One UI Settings Optimization

### Battery Protection
**Path:** `Settings > Battery > More battery settings > Battery protection`

| Mode | Behavior | Recommendation |
|------|----------|----------------|
| Basic | Charges to 100%, no protection | ❌ Never use |
| Adaptive | AI-based, unpredictable | ⚠️ Avoid |
| Maximum | Hard cap at 80% | ✅ **Use this** |

### Power Mode
**Path:** `Settings > Battery > Power mode`

| Mode | Effect | Recommendation |
|------|--------|----------------|
| Light | Reduced performance, longer battery | Good for idle periods |
| Optimized | Balanced | ✅ **Daily driver** |
| High performance | Max speed, more heat | ❌ Avoid in hot climate |

### RAM Plus
**Path:** `Settings > Device care > Memory > RAM Plus`

| Setting | Effect | Recommendation |
|---------|--------|----------------|
| Off | Less storage writes, less background swap | ✅ If you don't heavy multitask |
| 2GB | Minimal swap | ✅ Acceptable |
| 4GB+ | More storage writes | ❌ Avoid for longevity |

### Display (Keep Your 120Hz)
- Keep **120Hz** as desired
- Enable **Adaptive brightness**
- Consider **Dark mode** (reduces OLED power + burn-in risk)
- Disable **Always On Display** or set to "Tap to show"

### Network
- Keep **LTE preferred** (5G uses 30-40% more power)
- Disable **Wi-Fi scanning** and **Bluetooth scanning** when not needed
- **Path:** `Settings > Location > Location services`

---

## Phase 3: Hotspot/Tethering Protocol

### Heat Generation Ranking (Lowest to Highest)
1. **USB Tethering** - 60-80% less heat than WiFi hotspot ✅
2. **Bluetooth Tethering** - Low heat, but slow
3. **2.4GHz WiFi Hotspot** - Moderate heat
4. **5GHz WiFi Hotspot** - Adds 5-8°C vs 2.4GHz ❌

### Samsung Hotspot Thermal Thresholds
| Temp | Behavior |
|------|----------|
| 36-40°C | Safe operation |
| 40-43°C | Throttling begins |
| 43-45°C | Emergency throttling |
| >45°C | Force-disable hotspot |

### Hotspot Rules for Jakarta Climate
1. **Prefer USB tethering** when ambient >30°C
2. **Never hotspot while charging** if ambient >30°C
3. If WiFi hotspot required: use **2.4GHz**, keep phone in shade with airflow
4. Keep hotspot sessions **as short as possible**
5. **Screen off** during hotspot

---

## Phase 4: ADB Thermal Monitoring

### Setup Monitoring Script

Create `~/bin/a56_temp_monitor.sh`:

```bash
#!/bin/bash
# Galaxy A56 Temperature Monitor
# Usage: ./a56_temp_monitor.sh [interval_seconds]

INTERVAL=${1:-10}

echo "Monitoring battery temperature (Ctrl+C to stop)..."
echo "Timestamp,Temp(°C),Level(%),Status"

while true; do
    DATA=$(adb shell dumpsys battery 2>/dev/null)
    TEMP=$(echo "$DATA" | grep temperature | awk '{printf "%.1f", $2/10}')
    LEVEL=$(echo "$DATA" | grep level | head -1 | awk '{print $2}')
    STATUS=$(echo "$DATA" | grep status | awk '{print $2}')
    
    # Status codes: 1=unknown, 2=charging, 3=discharging, 4=not charging, 5=full
    case $STATUS in
        2) STATUS_STR="Charging" ;;
        3) STATUS_STR="Discharging" ;;
        5) STATUS_STR="Full" ;;
        *) STATUS_STR="Unknown" ;;
    esac
    
    echo "$(date '+%H:%M:%S'),$TEMP,$LEVEL,$STATUS_STR"
    
    # Alert if temp >= 40°C
    if (( $(echo "$TEMP >= 40" | bc -l) )); then
        echo "⚠️  WARNING: Battery temp $TEMP°C - consider stopping charge"
    fi
    
    sleep $INTERVAL
done
```

### Quick Temperature Check Commands

```bash
# One-time temperature check
adb shell dumpsys battery | grep temperature | awk '{printf "Battery: %.1f°C\n", $2/10}'

# Full battery status
adb shell dumpsys battery

# Thermal service status
adb shell dumpsys thermalservice

# Reset battery stats (for fresh monitoring)
adb shell dumpsys batterystats --reset
```

### Temperature Interpretation
| Reading | Meaning | Action |
|---------|---------|--------|
| <300 (30°C) | Excellent | Continue |
| 300-350 | Good | Continue |
| 350-400 | Moderate | Monitor closely |
| 400-420 | High | Consider pausing charge |
| >420 | Critical | **Stop charging immediately** |

---

## Phase 5: ADB Debloat (Conservative)

### Safety Rules
1. **Never touch**: Knox, telephony, IMS, SystemUI, timezone packages
2. **Use disable first**: `pm disable-user --user 0 <package>` (reversible)
3. **Batch size**: 3-5 packages at a time
4. **Test after each batch**: Calls, SMS, camera, biometrics, BRImo
5. **Wait 2-3 days** between batches

### Rollback Commands
```bash
# Re-enable disabled package
adb shell pm enable <package>

# Reinstall uninstalled package
adb shell cmd package install-existing <package>

# List disabled packages
adb shell pm list packages -d
```

### Phase 5.1: Minimal Debloat (Start Here)

**Lowest risk, highest impact on background load:**

```bash
# Bixby (voice assistant - if unused)
adb shell pm disable-user --user 0 com.samsung.android.bixby.agent
adb shell pm disable-user --user 0 com.samsung.android.visionintelligence

# AR Features (if unused)
adb shell pm disable-user --user 0 com.samsung.android.aremoji
adb shell pm disable-user --user 0 com.samsung.android.arzone

# Samsung Tips/Promotions
adb shell pm disable-user --user 0 com.samsung.android.app.tips

# Game Launcher (if no gaming)
adb shell pm disable-user --user 0 com.samsung.android.game.gamehome
adb shell pm disable-user --user 0 com.samsung.android.game.gametools

# Telemetry/Analytics
adb shell pm disable-user --user 0 com.samsung.android.voc
adb shell pm disable-user --user 0 com.samsung.android.da.daagent
```

**After this batch:** Reboot, test calls/SMS/camera/BRImo, use normally for 2-3 days.

### Phase 5.2: Extended Debloat (If Phase 5.1 Stable)

```bash
# Theme Store (if using default theme)
adb shell pm disable-user --user 0 com.samsung.android.themestore

# Samsung Free (news/entertainment panel)
adb shell pm disable-user --user 0 com.samsung.android.app.spage

# Facebook preloads (if not using Facebook)
adb shell pm disable-user --user 0 com.facebook.katana
adb shell pm disable-user --user 0 com.facebook.system
adb shell pm disable-user --user 0 com.facebook.appmanager

# Microsoft preloads (if unused)
adb shell pm disable-user --user 0 com.microsoft.skydrive
adb shell pm disable-user --user 0 com.microsoft.office.outlook
```

### Phase 5.3: Aggressive Debloat (Optional, Higher Risk)

**Only if you're confident and have tested thoroughly:**

```bash
# Samsung Browser (if using Firefox/Chrome)
adb shell pm disable-user --user 0 com.sec.android.app.sbrowser

# Samsung Calendar (if using Google Calendar)
adb shell pm disable-user --user 0 com.samsung.android.calendar

# Samsung Notes (if using alternative)
adb shell pm disable-user --user 0 com.samsung.android.app.notes
```

### NEVER TOUCH LIST

| Package Pattern | Reason |
|-----------------|--------|
| `com.samsung.android.knox.*` | Breaks banking (BRImo) |
| `com.sec.android.app.telephony*` | Breaks calls |
| `com.android.providers.telephony` | Breaks SMS |
| `com.samsung.android.incallui` | Breaks call UI |
| `com.android.systemui` | Bricks device |
| `com.google.android.gms` | Breaks Play services |
| `*timezone*` | Can cause bootloop |
| `com.samsung.android.biometrics*` | Breaks fingerprint |

---

## Phase 6: FOSS Apps Installation

### Recommended Apps (No Root Required)

| App | Purpose | Package | Source |
|-----|---------|---------|--------|
| **Aegis** | 2FA with encrypted backup | `com.beemdevelopment.aegis` | F-Droid |
| **Syncthing** | Local file sync | `com.nutomic.syncthingandroid` | F-Droid |
| **NetGuard** | Firewall (lowest battery) | `eu.faircode.netguard` | F-Droid |
| **Fennec** | Firefox without telemetry | `org.mozilla.fennec_fdroid` | F-Droid |
| **NewPipe** | YouTube (audio-only mode) | `org.schabi.newpipe` | F-Droid |
| **Organic Maps** | Offline navigation | `app.organicmaps` | F-Droid |

### Installation Steps

1. **Install F-Droid**: Download from https://f-droid.org
2. **Add IzzyOnDroid repo** (optional, more apps): `https://apt.izzysoft.de/fdroid/repo`
3. **Install apps** from F-Droid

### Warnings
- **VPN apps conflict**: Only one VPN-based app at a time (NetGuard, RethinkDNS, TrackerControl)
- **BRImo may detect VPN**: Test with BRImo after installing NetGuard
- **Syncthing**: Development discontinued Dec 2024, but still works; monitor for alternatives

### Aegis 2FA Setup (Critical for 7-Year Plan)
1. Install Aegis from F-Droid
2. **Enable encryption** with strong password
3. **Export encrypted backup** to PC monthly
4. Store backup in multiple locations (PC + USB drive)

---

## Phase 7: Maintenance Schedule Integration

### Daily (Passive)
- Observe charging temperature (should feel "cool to warm", never "hot")
- Keep in shade during charging
- Prefer USB tethering over WiFi hotspot

### Weekly
- Check battery health in Samsung Members app
- Review battery usage for anomalies
- Clear app caches if storage dropping

### Monthly
- Run `galaxy_a56_audit_v2.sh` for device snapshot
- Export Aegis backup to PC
- Syncthing: Verify sync is completing
- Check free storage (maintain >20%)

### Quarterly
- Full Smart Switch backup to PC
- Test restore on different device (if available)
- Review disabled packages: re-enable any you miss
- Update FOSS apps from F-Droid

### Yearly
- Reassess charging habits vs temperature logs
- Replace USB cable if loose/intermittent
- Check Samsung battery health report
- Plan battery replacement if capacity <80%

---

## Appendix A: Quick Reference Card

### Temperature Thresholds
| Temp | Status | Action |
|------|--------|--------|
| <35°C | ✅ Safe | Continue |
| 35-40°C | ⚠️ Warm | Monitor |
| 40-42°C | 🔶 High | Consider pausing |
| >42°C | 🔴 Critical | Stop charging |

### ADB Quick Commands
```bash
# Check temp
adb shell dumpsys battery | grep temp

# List disabled packages
adb shell pm list packages -d

# Re-enable package
adb shell pm enable <package>
```

### Emergency Contacts
- Samsung Service Center Indonesia: 021-56997777
- Nearest authorized center: Check samsung.com/id

---

## Appendix B: Research Sources

1. **Battery University** - Lithium-ion degradation curves and temperature effects
2. **XDA Developers** - Samsung debloat guides and package safety lists
3. **Samsung Community Forums** - One UI settings documentation
4. **F-Droid / IzzyOnDroid** - FOSS app repositories
5. **Android Developer Docs** - ADB command reference
6. **GitHub Universal Android Debloater** - Package safety database

---

*Document generated from multi-source research synthesis. Last updated: 2026-01-06*
