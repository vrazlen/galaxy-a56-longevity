# Device Baseline & Configuration

**Device:** Samsung Galaxy A56 5G  
**OS:** Android (One UI Stock)  
**Security:** Knox Enforced, OEM Locked

## 1. Initial Setup for Longevity

To maximize hardware lifespan in a hot climate (Indonesia), these settings must be applied immediately after unboxing or factory reset.

### Battery & Power
*   **Settings > Battery > Battery Protection:** Set to **Maximum** (stops at 80%) or **Adaptive**.
    *   *Reason:* Lithium-ion degrades fastest at high voltage (100%) + high heat. 80% is the "sweet spot" for 7-year chemistry.
*   **Settings > Battery > Process Speed:** Set to **Optimized** (default). Avoid "Maximum" or "High".
*   **Fast Charging:** **Disable** for overnight charging. Enable only for emergency top-ups.
    *   *Reason:* Fast charging generates significant heat.

### Display (OLED Preservation)
*   **Settings > Display > Dark Mode:** **Always ON**.
    *   *Reason:* Reduces power consumption and uneven pixel wear (burn-in).
*   **Brightness:** Auto-brightness enabled, but cap maximum manual brightness indoors.
*   **Screen Timeout:** 1 minute.

### Connectivity
*   **5G vs 4G:** If 5G signal is weak/hot in your area (common in parts of Indonesia), switch to **LTE/4G Only**.
    *   *Path:* Settings > Connections > Mobile Networks > Network Mode > LTE/3G/2G (Auto connect).
    *   *Reason:* Searching for weak 5G signals drains battery and generates modem heat.

## 2. App Ecosystem (Student/Light Profile)

### Essential Apps (Do Not Remove)
*   **Samsung Pass:** Critical for password management.
*   **Google Authenticator:** 2FA.
*   **BRImo:** Banking. **Note:** Often detects "Developer Options". See *Maintenance Schedule* for toggling protocol.
*   **WhatsApp:** Primary comms. Backup set to Google Drive (Daily) AND Local Export (Monthly).

### Debloat Philosophy
Since we require banking apps and stability, we do **not** use aggressive `adb uninstall` scripts that break dependencies.
*   **Action:** Disable unused Samsung/Google apps via Settings > Apps > [App Name] > **Disable**.
*   **Target:** Bixby (if unused), AR Zone, Samsung Free, Microsoft Apps (if unused).

## 3. Security Baseline
*   **Lock Screen:** Fingerprint + Strong PIN (6+ digits).
*   **Find My Mobile:** Enable "Offline Finding" and "Send last location".
*   **Auto Blocker:** **ON** (One UI 6+ feature). Blocks sideloading and malicious USB commands.
    *   *Note:* Must be temporarily disabled to run ADB maintenance scripts.

## 4. Audit Reference
Baseline established using `galaxy_a56_audit_v2.sh`.
*   **Key Check:** `getprop ro.boot.warranty_bit` must be `0` (Knox valid).
*   **Storage Encryption:** `ro.crypto.state` must be `encrypted`.
