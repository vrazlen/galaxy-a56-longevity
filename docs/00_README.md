# Samsung Galaxy A56 5G: Project 7-Year Longevity

**Version:** 1.0.0  
**Target Device:** Samsung Galaxy A56 5G (SM-A566B)  
**Host Environment:** Fedora Workstation 43  
**Region/Climate:** Indonesia (Tropical/High Ambient Temp)  
**Profile:** Student / Light Usage / High Security / No Root

## Project Overview

This repository contains the operational runbooks and documentation to sustain a Samsung Galaxy A56 5G for a 7-year service life (2026–2033). The philosophy is **"Set and Forget"** with rigorous but infrequent maintenance windows.

### Core Principles
1.  **Hardware Preservation:** Aggressive heat management and battery chemistry preservation (80% charge limits) to survive Indonesian climate.
2.  **Software Stability:** Stock One UI firmware only. No root. No bootloader unlocking. This ensures banking apps (BRImo) and Knox-dependent features (Samsung Pass) function permanently.
3.  **Data Sovereignty:** Local-first backups using `adb` and `scrcpy`. Cloud sync is secondary/convenience only.
4.  **Privacy:** Strict control over device identifiers (IMEI, Serial, PII) in all logs and reports.

## Directory Structure

| File | Description |
|------|-------------|
| `01_DEVICE_BASELINE.md` | Initial configuration, settings for longevity, and hardware state. |
| `02_PRIVACY_REDACTION.md` | Rules for handling log files (`dumpstate`, audits) and redacting PII. |
| `03_MAINTENANCE_SCHEDULE.md` | Weekly, Monthly, and Yearly checklists for health and hygiene. |
| `04_TOOLBOX_SETUP.md` | Setting up the Fedora 43 workstation for Android management. |
| `05_DISASTER_RECOVERY.md` | Protocols for broken screens, lost devices, and 2FA lockout. |

## Quick Start (Auditing)

We utilize local scripts to capture device state without sending data to the cloud.

```bash
# Connect device via USB
# Ensure ADB Debugging is ON (See 04_TOOLBOX_SETUP.md)
./galaxy_a56_audit_v2.sh
```

## Critical Warnings

*   **Temperature:** Do not charge this device if ambient temperature exceeds 35°C unless actively cooling.
*   **Security:** Never leave "USB Debugging" enabled when using banking apps (BRImo). Toggle it on only during maintenance windows.
*   **Backup:** 2FA tokens (Google Authenticator) are the single point of failure. Back them up offline immediately.
