# Toolbox Setup (Fedora Workstation 43)

This guide sets up the local management environment on your laptop.

## 1. Install Dependencies
We rely on standard repositories. Fedora 43 should have recent versions.

```bash
# Update system
sudo dnf update -y

# Install Android tools and utilities
sudo dnf install android-tools scrcpy fastboot git -y
```

## 2. Configure USB Permissions (udev)
Allow non-root access to the Samsung device.

```bash
# Create rule file
sudo nano /etc/udev/rules.d/51-android.rules

# Add the following line (Samsung Vendor ID = 04e8)
SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"

# Reload rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```

## 3. Connection Protocol
1.  **On Phone:** Enable Developer Options (Tap Build Number 7 times).
2.  **On Phone:** Enable **USB Debugging**.
    *   *Prompt:* "Allow USB debugging?" -> Check "Always allow from this computer".
3.  **On PC:** Verify connection.
    ```bash
    adb devices
    # Output should look like:
    # R58T1234567    device
    ```
4.  **Important:** Turn OFF "USB Debugging" when finished to allow banking apps (BRImo) to run without warnings.

## 4. Helper Aliases
Add these to your `~/.bashrc` or `~/.zshrc` for efficiency.

```bash
# Quick device shell
alias a56='adb shell'

# Screen mirror (High quality, stay awake, audio forwarded)
alias mirror='scrcpy --stay-awake --turn-screen-off --max-size=1024 --bit-rate=8M'

# Pull photos
alias pull-photos='adb pull /sdcard/DCIM/Camera/ ~/Work/ecosystem/backups/A56_Photos/'

# Battery Status Check
alias check-batt='adb shell dumpsys battery'
```

## 5. Directory Layout
Maintain a disciplined folder structure on Fedora.

```text
~/Work/ecosystem/galaxy-a56/
├── audits/           # Output from audit scripts
├── backups/
│   ├── photos/
│   ├── whatsapp/
│   └── adb-full/
├── docs/             # This documentation
├── scripts/          # galaxy_a56_audit.sh, etc.
└── apks/             # Archived versions of critical apps (NetGuard, etc.)
```
