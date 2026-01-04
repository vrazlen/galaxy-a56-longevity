# Maintenance Schedule

To achieve 7 years of operation, proactive maintenance is required.

## Daily / Continuous
*   **Heat Management:**
    *   Avoid leaving phone on dashboard or in direct sunlight (Indonesia sun is intense).
    *   If phone feels hot (>40°C), remove case and stop heavy tasks.
*   **Charging:**
    *   Charge in a cool, ventilated area.
    *   Disconnect once charged (if not using Battery Protection limit).

## Weekly (Sunday Night)
1.  **Restart:** `Settings > General Management > Reset > Auto restart` or manual reboot. Clears memory leaks and zombie processes.
2.  **Update Check:** Check for One UI / Security Patches.
    *   *Rule:* Do not install major OS updates (e.g., Android 16 to 17) on Day 1. Wait 2 weeks for community feedback regarding bugs/battery drain.
3.  **Clean Screen:** Wipe with microfiber. Check for grit under the case (causes scratching).

## Monthly (1st of Month)
1.  **Local Backup:** Connect to Fedora Workstation.
    *   Run `adb backup` (if supported) or manually copy `DCIM`, `Pictures`, `Download`, `Documents`.
    *   Export WhatsApp chats to Internal Storage, then pull to PC.
2.  **App Audit:** Remove any "flavor of the month" apps installed but not used.
3.  **Storage Check:** Maintain at least 20% free space. Flash storage degrades faster when full.

## Bi-Yearly (June / December)
1.  **Toolbox Update:** Update `platform-tools` and `scrcpy` on Fedora host.
2.  **Cache Partition Wipe:**
    *   Turn off device.
    *   Connect via USB to PC (Required for A56 to enter Recovery).
    *   Hold `Vol Up + Power`.
    *   Select `Wipe Cache Partition`. **(DO NOT select Wipe Data/Factory Reset)**.
    *   *Reason:* Clears accumulated temp files that often cause battery drain after updates.

## Yearly (January)
1.  **The "Big" Audit:** Run `galaxy_a56_audit_v2.sh`. Compare battery health metrics against previous year.
2.  **2FA Drill:** Verify you can access backup codes for Google/Samsung accounts. Generate new ones if old ones are lost.
3.  **Physical Inspection:** Check USB-C port for lint. Check battery for swelling (back cover lifting).
