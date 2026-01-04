# Disaster Recovery Runbook

**Goal:** Restore functionality within 4 hours of a catastrophic failure (Loss, Theft, Breakage).

## Scenario A: Broken Screen (Touch Dead, Display Dead)
*Phone is on, but you can't see or touch anything.*

1.  **Connect to Fedora Toolbox.**
2.  **Unlock via scrcpy:**
    If you authorized ADB previously (see *Toolbox Setup*), `scrcpy` will work even with a black screen.
    ```bash
    scrcpy --turn-screen-off
    ```
    Use your mouse to draw the pattern or enter PIN.
3.  **Backup Immediately:**
    Once unlocked, proceed to *Monthly Backup* procedure.
4.  **Samsung Dex (Check Capability):**
    If `scrcpy` fails, connect a USB-C Hub with HDMI. The A56 *may* support basic screen mirroring over HDMI (verify this while screen is working!). Connect mouse/keyboard to hub to navigate.

## Scenario B: Lost or Stolen Device
*Device is gone. Data protection is priority.*

1.  **Locate:**
    *   Log into [SmartThings Find](https://smartthingsfind.samsung.com) or [Google Find My Device](https://www.google.com/android/find).
2.  **Secure:**
    *   Set **"Lock"** mode immediately. Displays a recovery message.
    *   If recovery is impossible, execute **"Erase"**.
3.  **SIM Card:**
    *   Call carrier (Telkomsel/Indosat/etc.) to block the SIM. This prevents SMS 2FA intercept.
4.  **Banking:**
    *   Log into internet banking via PC. Change passwords. Delink the mobile device from BRImo if possible via web interface.

## Scenario C: 2FA Lockout (Lost Phone + No Backup)
*You cannot login to Gmail/Samsung because the codes are on the lost phone.*

1.  **Use Backup Codes:**
    *   Retrieve the printed/saved backup codes generated during *Yearly Maintenance*.
2.  **Trusted Number/Email:**
    *   Use the recovery phone number or secondary email configured in Google Account settings.
3.  **Prevention:**
    *   **Action:** Open Google Authenticator > Settings > Transfer accounts > Export.
    *   Save the QR code image, print it, and lock it in a physical safe/drawer.
    *   *Alternative:* Run a secondary old phone with Google Authenticator synced.

## Scenario D: Accidental Factory Reset / Bootloop
1.  **Restore from Cloud:**
    *   Samsung Cloud backs up: Call logs, SMS, Settings, Home Screen layout.
    *   Google Drive backs up: WhatsApp, Photos (if enabled), Contacts.
2.  **Restore from Local:**
    *   Connect to PC. Copy back `DCIM` and `Documents` folders.
    *   Re-login to apps.

## Scenario E: "Developer Options" Detected by Banking App
*BRImo refuses to open.*

1.  **Disable Debugging:**
    *   Settings > Developer Options > USB Debugging > **OFF**.
2.  **Disable Developer Mode (If #1 fails):**
    *   Settings > Developer Options > Toggle Top Bar to **OFF**.
3.  **Clear App Cache:**
    *   Settings > Apps > BRImo > Storage > Clear Cache.
    *   Restart phone.
