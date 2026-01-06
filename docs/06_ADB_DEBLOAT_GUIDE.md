# Samsung Galaxy A56 5G ADB Debloat Guide
**One UI 7 (Android 15) - Generated: 2026-01-06**

## ⚠️ CRITICAL WARNINGS

### NEVER TOUCH - Banking & Knox Compatibility
These packages will BREAK:
- BRImo & banking apps (Knox security checks)
- Samsung Pay
- Secure Folder
- Device boot process

**DO NOT REMOVE:**
- Any package with `knox` in the name (see Knox section below)
- `com.samsung.android.timezone.*` - **BOOTLOOP RISK**
- `com.samsung.android.SettingsReceiver` - System critical
- `com.samsung.android.applock` - Security layer
- `com.samsung.android.networkstack*` - Network critical
- `com.sec.android.app.launcher` - Launcher/home screen
- `com.sec.android.inputmethod` - Samsung Keyboard
- `com.samsung.android.honeyboard` - Alternative keyboard
- `com.sec.imsservice` / `com.sec.ims` - Calling/VoLTE
- `com.samsung.android.incallui` - Phone calls UI
- `com.samsung.android.communicationservice` - Core comms
- `com.sec.epdg` - VoLTE/WiFi calling
- `com.samsung.ucs.agent.boot` - Boot verification
- `com.samsung.android.wifi.resources` - WiFi critical

---

## 🟢 SAFE TO DISABLE - Bloatware

### Samsung Apps & Services (67 packages)
```
com.samsung.android.app.notes          # Samsung Notes (use Google Keep/etc)
com.samsung.android.app.tips           # Samsung Tips
com.samsung.android.bixby.agent        # Bixby voice assistant
com.samsung.android.bixbyvision.framework
com.samsung.android.beaconmanager
com.samsung.android.app.spage          # Samsung Daily/Free
com.samsung.android.app.sbrowseredge   # Samsung Internet (use Chrome/Firefox)
com.samsung.android.themestore         # Theme Store
com.samsung.android.themecenter
com.samsung.android.app.watchmanager   # Galaxy Watch pairing
com.samsung.android.app.watchmanagerstub
com.samsung.android.aremoji            # AR Emoji
com.samsung.android.aremojieditor
com.samsung.android.arzone             # AR Zone
com.samsung.android.ardrawing
com.samsung.android.game.gamehome      # Game Launcher
com.samsung.android.game.gametools     # Game Tools overlay
com.samsung.android.game.gos           # Game Optimizing Service
com.samsung.android.gametuner.thin
com.samsung.android.email.provider     # Samsung Email
com.samsung.android.calendar           # Samsung Calendar (use Google)
com.samsung.android.messaging          # Samsung Messages (use Google)
com.samsung.android.authfw             # Samsung authentication framework
com.samsung.android.app.omcagent       # OEM customization agent
com.samsung.android.da.daagent         # Device Analyzer telemetry
com.samsung.android.dqagent            # Data Quality Agent
com.samsung.android.fmm                # Find My Mobile (if not used)
com.samsung.android.app.social         # Social sharing service
com.samsung.android.app.news           # Samsung Free news
com.samsung.android.app.memo           # Samsung Memo (legacy)
com.samsung.android.app.reminder       # Samsung Reminders
com.samsung.android.intelligenceservice2  # AI/Bixby service
com.samsung.android.app.simplesharing
com.samsung.android.app.cocktailbarservice  # Edge panel services
com.samsung.android.app.taskedge
com.samsung.android.app.appsedge
com.samsung.android.app.clipboardedge
com.samsung.android.easysetup          # Quick Share setup
com.samsung.android.allshare.service.mediashare  # Media sharing (DLNA)
com.samsung.android.allshare.service.fileshare
com.samsung.android.smartmirroring     # Smart View/Screen mirroring
com.samsung.android.mdx                # Samsung DeX
com.samsung.android.mdx.quickboard
com.samsung.android.app.withtv         # TV connectivity
com.samsung.android.homemode           # SmartThings Home mode
com.samsung.android.drivelink.stub     # Android Auto stub
com.samsung.android.app.mirrorlink
com.samsung.android.fast               # Secure Wi-Fi (VPN service)
com.samsung.android.icecone            # Data usage monitoring
com.samsung.android.visionintelligence  # Bixby Vision
com.samsung.android.app.settings.bixby
com.samsung.android.bbc.bbcagent       # Big Data Collection agent
com.samsung.android.bbc.fileprovider
com.samsung.attribution                # Analytics/attribution
com.samsung.aasaservice                # Ahead-of-time compilation service
com.samsung.android.mobileservice      # Samsung Cloud/Account services
com.samsung.android.scloud             # Samsung Cloud (if not used)
com.samsung.android.voc                # Voice of Customer feedback
com.samsung.android.app.sharelive      # Live sharing features
com.samsung.app.highlightplayer        # Video highlight player
com.samsung.android.app.episodes       # Story/episode viewer
com.samsung.android.app.storyalbumwidget
com.samsung.android.forest             # Digital Wellbeing forest (use Google's)
com.samsung.android.wellbeing          # Samsung Wellbeing (use Google's)
com.samsung.android.widget.pictureframe
com.samsung.storyservice               # Story service
com.samsung.android.app.ledcoverdream  # LED cover support
```

### Samsung Pay & Wallet (if not used)
```
com.samsung.android.spay               # Samsung Pay
com.samsung.android.spayfw             # Samsung Pay framework
com.samsung.android.samsungpass        # Samsung Pass password manager
com.samsung.android.samsungpassautofill
com.samsung.android.coldwalletservice  # Crypto wallet
```

### AR/Camera Stickers (10 packages)
```
com.samsung.android.app.camera.sticker.facearavatar.preload
com.samsung.android.app.camera.sticker.facearframe.preload
com.samsung.android.app.camera.sticker.stamp.preload
com.samsung.android.stickercenter
com.samsung.android.provider.stickerprovider
com.sec.android.mimage.avatarstickers
```

### Samsung Knox Features (SAFE to remove if not using enterprise/Secure Folder)
```
com.samsung.knox.securefolder          # Secure Folder app
com.samsung.knox.securefolder.setuppage
com.samsung.android.knox.analytics.uploader  # Analytics
com.samsung.android.knox.attestation
com.samsung.android.knox.containercore
com.samsung.android.knox.containerdesktop
com.samsung.android.knox.containeragent
com.samsung.android.knox.kpecore
com.samsung.android.knox.pushmanager
com.samsung.knox.knoxtrustagent
com.samsung.knox.kss
com.knox.vpn.proxyhandler
com.sec.enterprise.knox.attestation
com.sec.enterprise.knox.cloudmdm.smdms  # Enterprise MDM
com.sec.enterprise.knox.shareddevice.keyguard
com.sec.knox.bluetooth                  # Knox Bluetooth (regular BT unaffected)
com.sec.knox.bridge
com.sec.knox.containeragent2
com.sec.knox.foldercontainer
com.sec.knox.knoxsetupwizardclient
com.sec.knox.packageverifier
com.sec.knox.shortcutsms
com.sec.knox.switchknoxII
com.sec.knox.switchknoxI
com.sec.knox.switchknox
com.samsung.knox.rcp.components
```

### Carrier Bloatware (if applicable)
```
# T-Mobile
com.tmobile.echolocate
com.tmobile.pr.adapt
com.tmobile.simlock
com.tmobile.services
com.tmobile.vvm.application
com.ironsrc.aura.tmo

# Verizon
com.vzw.apnlib
com.vzw.ecid
com.vzw.hss.myverizon
com.vzw.hs.android.modlite
com.vcast.mediamanager
com.verizon.llkagent
com.verizon.mips.services
com.vzw.visualvoicemail
com.samsung.vzwapiservice
com.verizon.obdm
com.securityandprivacy.android.verizon.vms
com.verizon.onetalk.dialer

# AT&T
com.att.dh
com.att.callprotect
com.att.tv
com.att.myWireless
com.att.visualvoicemail
com.att.android.attsmartwifi
com.samsung.attvvm
com.sec.android.app.ewidgetatt

# Others
com.boost.vvm
com.sprint.ms.smf.services
com.sprint.provider
com.sec.sprint.wfcstub
com.cricketwireless.mycricket
com.mizmowireless.tethering
com.aura.oobe.samsung.gl
com.aura.oobe.samsung
com.aura.oobe.att
com.aura.oobe.deutsche
com.xfinitymobile.cometcarrierservice
com.spectrum.cm.headless
com.uscc.ecid
```

### Microsoft Bloatware
```
com.microsoft.appmanager
com.microsoft.skydrive                 # OneDrive
```

---

## 🟡 CAUTION - May Break Minor Features

### Advanced Removal (58 packages)
Remove ONLY if you understand the consequences:

```
com.samsung.android.app.routines       # Bixby Routines automation (EXPERT level)
com.samsung.android.alive.service      # Battery/performance monitoring
com.samsung.android.aliveprivacy
com.samsung.android.aware.service      # Context awareness
com.samsung.android.app.dressroom      # Theme customization
com.samsung.android.dynamiclock        # Dynamic lock screen
com.samsung.android.location           # Location services layer
com.samsung.android.mdagent            # Diagnostic monitoring
com.samsung.android.net.wifi.wifiguider
com.samsung.android.photoremasterservice  # AI photo enhancement
com.samsung.android.smartface          # Face recognition (photos)
com.samsung.android.app.galaxyfinder   # Samsung search
com.samsung.android.app.smartcapture   # Screenshot tools
com.samsung.android.app.smartwidget
com.samsung.android.mcfserver          # Multi-device connectivity
com.samsung.app.newtrim                # Video trimmer
com.samsung.android.app.multiwindow    # Multi-window support
com.samsung.android.bio.face.service   # Face unlock (KEEP if using)
com.samsung.android.biometrics         # Biometric framework
com.samsung.android.biometrics.app.setting
com.samsung.android.bluelightfilter    # Blue light filter
com.samsung.android.fingerprint.service  # Fingerprint (KEEP if using)
com.samsung.android.lool               # Edge lighting
com.samsung.android.provider.shootingmodeprovider  # Camera modes
com.samsung.android.sm.devicesecurity  # Device care security
com.samsung.android.server.iris        # Iris scanner (old devices)
com.samsung.android.spdclient          # Samsung Push Service
com.samsung.android.app.aodservice     # Always On Display
com.samsung.android.app.motionpanoramaviewer
com.samsung.android.app.selfmotionpanoramaviewer
com.samsung.android.app.interactivepanoramaviewer
com.samsung.android.emojiupdater       # Emoji updates
com.samsung.android.provider.filterprovider
com.samsung.android.service.pentastic  # S Pen features (EXPERT - tablets/Note)
com.samsung.accessibility              # Samsung accessibility (EXPERT)
com.samsung.android.app.advsounddetector  # Sound notifications
com.samsung.android.app.assistantmenu  # Accessibility menu
com.samsung.android.app.talkback       # Screen reader
com.samsung.android.app.color          # Color customization
com.samsung.android.app.filterinstaller
com.samsung.android.app.pinboard       # Pinboard widget
com.samsung.android.asksmanager        # Secure Keystore manager
com.samsung.android.dlp.service        # Data leak prevention
com.samsung.android.gearoplugin        # Gear VR plugin
com.samsung.android.hmt.vrshell        # VR shell
com.samsung.android.hmt.vrsvc          # VR service
com.samsung.android.app.vrsetupwizardstub
com.samsung.cmfa.AuthTouch             # Touch authentication
com.samsung.klmsagent                  # Key management
com.samsung.SMT                        # Samsung maintenance
com.sec.android.app.apex               # Samsung APK/update service
com.sec.android.diagmonagent           # Diagnostics monitoring
com.sec.android.app.safetyassurance    # Safety features
com.sec.android.splitsound             # Separate app sound
com.sec.phone                          # Phone services overlay (EXPERT)
com.sec.sve                            # Samsung Video Editor
com.sec.usbsettings                    # USB settings
com.samsung.advp.imssettings           # IMS settings (EXPERT - calling)
com.samsung.android.app.amcagent       # Account management
```

---

## 🔴 NEVER TOUCH - System Critical

### Bootloop/Brick Risk
```
com.samsung.android.timezone.autoupdate_O      # **WILL BOOTLOOP**
com.samsung.android.timezone.data.updater      # **WILL BOOTLOOP**
com.samsung.android.timezone.data_Q
com.samsung.android.timezone.data.P
com.samsung.ucs.agent.boot                     # Boot verification
com.samsung.android.SettingsReceiver           # Settings overlay
com.samsung.android.app.soundpicker            # System sound picker
```

### Knox Core (Banking/Security)
```
com.samsung.knox.keychain                      # **UNSAFE - Credential storage**
com.samsung.android.knox.app.networkfilter     # **EXPERT - Bluetooth dependency**
com.samsung.android.knox.zt.framework          # **ADVANCED - Touch dynamics**
com.samsung.android.knox.mpos                  # **ADVANCED - Payments**
com.samsung.android.knox.er                    # **ADVANCED - Enterprise**
com.samsung.android.knox.kfbp                  # **EXPERT - Graphics**
com.samsung.android.knox.knnr                  # **EXPERT - ML runtime**
com.samsung.android.knox.sandbox               # **EXPERT - Isolation**
com.samsung.knox.appsupdateagent               # **ADVANCED - App updates**
```

### Telephony/Network
```
com.sec.imsservice                    # IMS/VoLTE
com.sec.ims                           # IMS core
com.sec.epdg                          # VoLTE/WiFi calling
com.samsung.android.incallui          # In-call UI
com.samsung.android.communicationservice
com.samsung.android.networkstack      # Network stack
com.samsung.android.networkstack.tethering.overlay
com.samsung.android.wifi.resources    # WiFi resources
com.samsung.android.app.telephonyui   # Telephony UI
com.samsung.android.callassistant     # Call features
com.sec.omadm                         # OMA device management (EXPERT)
com.sec.omadmspr.syncmlphoneif        # OMA sync (EXPERT)
```

### Launcher/UI
```
com.sec.android.app.launcher          # Samsung One UI Home
com.samsung.android.clipboarduiservice  # Clipboard
```

### Input Methods
```
com.sec.android.inputmethod           # Samsung Keyboard
com.samsung.android.honeyboard        # Alternative Samsung keyboard
```

### System Services
```
com.sec.android.app.simsettingmgr     # SIM settings
com.samsung.android.MtpApplication    # MTP/file transfer (EXPERT)
com.samsung.android.sm_cn             # System maintenance (EXPERT)
com.samsung.android.sm.policy         # Device care policy
com.samsung.android.camerasdkservice  # Camera SDK (EXPERT)
com.samsung.android.providers.carrier # Carrier provider (EXPERT)
com.sec.android.Cdfs                  # CDMA file system (EXPERT)
com.samsung.gamedriver.sm8250         # GPU driver (EXPERT - Snapdragon)
com.samsung.gamedriver.ex2100         # GPU driver (EXPERT - Exynos)
com.samsung.pregpudriver.ex2100       # Pre-GPU driver (EXPERT)
com.samsung.huxplatform               # HUX platform (EXPERT)
com.samsung.vklayer.sm8250            # Vulkan layer
com.samsung.phone.overlay.common      # Phone overlay (EXPERT)
com.samsung.android.localeoverlaymanager  # Locale manager (EXPERT)
com.samsung.android.providers.contacts  # Contacts provider (EXPERT)
com.samsung.android.providers.media   # Media provider (EXPERT)
com.samsung.android.setting.multisound  # Multi-sound (EXPERT)
com.samsung.android.sume.nn.service   # Neural network (EXPERT)
com.samsung.android.wifi.softapwpathree.resources  # Hotspot (EXPERT)
com.sec.android.systemupdate          # System updates (EXPERT)
com.sec.unifiedwfc                    # WiFi calling (EXPERT)
com.samsung.android.brightnessbackupservice  # Brightness (EXPERT)
com.samsung.android.container         # Container service (EXPERT)
com.samsung.android.gru               # GPU renderer (EXPERT)
com.samsung.ssu                       # Software Update (EXPERT)
com.samsung.euicc                     # eSIM (EXPERT)
com.samsung.android.app.clockpack     # Clock/alarms (EXPERT)
com.sec.android.app.SecSetupWizard    # Setup wizard (ADVANCED)
```

---

## 📋 ADB COMMAND SYNTAX

### Preparation
```bash
# 1. Enable USB Debugging on phone
Settings > About phone > Software information
Tap "Build number" 7 times
Settings > Developer options > USB debugging (ON)

# 2. Connect via USB and verify
adb devices
# Output should show: [DEVICE_ID]    device

# 3. If "unauthorized", check phone screen and tap "Allow"
```

### Disable Packages (Recommended Method)
```bash
# Disable single package (SAFER - can re-enable)
adb shell pm disable-user --user 0 com.samsung.android.bixby.agent

# Disable multiple packages from file
while read package; do
    adb shell pm disable-user --user 0 "$package"
done < packages_to_disable.txt
```

### Uninstall Packages (More Aggressive)
```bash
# Uninstall for current user (NOT system-wide - safer)
adb shell pm uninstall --user 0 com.samsung.android.bixby.agent

# Batch uninstall
while read package; do
    adb shell pm uninstall --user 0 "$package"
done < packages_to_remove.txt
```

### Re-enable Disabled Packages
```bash
# Re-enable single package
adb shell pm enable com.samsung.android.bixby.agent

# OR use cmd package
adb shell cmd package install-existing com.samsung.android.bixby.agent

# Restore multiple packages
while read package; do
    adb shell pm enable "$package"
    adb shell cmd package install-existing "$package"
done < packages_to_restore.txt
```

### List Packages
```bash
# List all packages
adb shell pm list packages

# List disabled packages
adb shell pm list packages -d

# List enabled packages
adb shell pm list packages -e

# Search for specific packages
adb shell pm list packages | grep samsung
adb shell pm list packages | grep bixby
```

### Check Package Status
```bash
# Check if package is enabled/disabled
adb shell pm list packages -d | grep com.samsung.android.bixby.agent

# Get package info
adb shell dumpsys package com.samsung.android.bixby.agent
```

---

## 🔧 RECOVERY PROCEDURES

### If Something Breaks After Disabling

**Option 1: Re-enable specific package**
```bash
adb shell pm enable com.package.name
adb shell cmd package install-existing com.package.name
```

**Option 2: Factory Reset (last resort)**
1. Backup data first
2. Settings > General management > Reset > Factory data reset
3. **IMPORTANT**: Export 2FA codes before reset!

**Option 3: Use Samsung Find My Mobile**
If you disabled something and phone is unstable:
1. Go to findmymobile.samsung.com
2. Sign in with Samsung account
3. Use "Unlock" or "Restore" features

---

## 📝 RECOMMENDED DEBLOAT STRATEGY

### Conservative Approach (Safest for A56 + BRImo banking)
1. **ONLY disable from "SAFE TO DISABLE" section**
2. Disable 5-10 packages at a time
3. Test phone functionality for 24 hours
4. Check: Banking apps, calls, SMS, WiFi, camera, biometrics
5. If all works, continue with next batch

### What to Disable First (Minimal Impact)
```
com.samsung.android.bixby.agent
com.samsung.android.bixbyvision.framework
com.samsung.android.app.tips
com.samsung.android.themestore
com.samsung.android.aremoji
com.samsung.android.aremojieditor
com.samsung.android.arzone
com.samsung.android.game.gamehome
com.samsung.android.game.gametools
com.samsung.android.game.gos
com.samsung.android.voc
com.samsung.android.app.omcagent
com.samsung.android.da.daagent
com.samsung.android.dqagent
```

### Knox Considerations
- **DO NOT touch Knox if using:**
  - BRImo or any banking app
  - Samsung Pass
  - Secure Folder
  - Work profile

- **CAN disable Knox features if:**
  - You don't use Secure Folder
  - No work/enterprise profile
  - Don't use Samsung Pass
  - Banking apps still work (TEST FIRST!)

---

## 🎯 A56-SPECIFIC NOTES

### Confirmed Safe for Galaxy A Series (2025-2026)
- All Bixby components (unless you use it)
- AR Emoji/AR Zone (A56 has basic camera)
- Game optimization (if not gaming)
- Samsung themes (can use default)
- Samsung Free/Daily
- Edge panels

### Keep for A56 Features
- `com.samsung.android.app.camera.*` - Camera features
- Biometric packages - Face/fingerprint unlock
- Samsung keyboard - Unless using Gboard
- Device care (`com.samsung.android.sm.*`) - Battery optimization

### One UI 7 Changes
- Bixby is more deeply integrated - disabling won't break other features
- Knox is required for BRImo and banking apps - **DO NOT REMOVE KNOX CORE**
- New AI features may depend on `intelligenceservice2` - disable carefully

---

## 📚 SOURCES

1. **Universal Android Debloater NG** (748 Samsung packages documented)
   - https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation
   - Community-verified removal safety ratings

2. **Samsung Debloater (One UI 7-8 focus)**
   - https://github.com/TheOneAndOnlyAtlas/Samsung-Debloater
   - Multi-mode batch script

3. **XDA Developers Forums**
   - Galaxy A series debloat threads
   - Knox banking compatibility reports

---

## ⚡ QUICK START SCRIPT

Save as `debloat_safe.sh`:

```bash
#!/bin/bash
# Safe debloat for Samsung A56 (One UI 7)

PACKAGES=(
    "com.samsung.android.bixby.agent"
    "com.samsung.android.bixbyvision.framework"
    "com.samsung.android.app.tips"
    "com.samsung.android.themestore"
    "com.samsung.android.aremoji"
    "com.samsung.android.aremojieditor"
    "com.samsung.android.arzone"
    "com.samsung.android.game.gamehome"
    "com.samsung.android.game.gametools"
    "com.samsung.android.voc"
    "com.samsung.android.app.omcagent"
    "com.samsung.android.da.daagent"
)

for pkg in "${PACKAGES[@]}"; do
    echo "Disabling: $pkg"
    adb shell pm disable-user --user 0 "$pkg"
done

echo "Done! Test your phone for 24 hours."
```

Run: `bash debloat_safe.sh`

---

**Last Updated:** 2026-01-06  
**Target Device:** Samsung Galaxy A56 5G  
**OS Version:** One UI 7 (Android 15)  
**Project:** ecosystem/galaxy_a56_audit

