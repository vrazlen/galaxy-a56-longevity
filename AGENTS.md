# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-06T18:07:42+07:00
**Commit:** 258a0c4
**Branch:** master

## OVERVIEW

Samsung Galaxy A56 5G 7-year longevity tracking (2026-2033). Shell scripts for ADB-based device audits, thermal monitoring, and documentation runbooks. Fedora 43 workstation target. Jakarta climate (~40°C ambient) drives aggressive thermal management.

## STRUCTURE

```
ecosystem/
├── galaxy_a56_audit.sh       # v1 audit script (ADB read-only)
├── galaxy_a56_audit_v2.sh    # v2 audit script (enhanced)
├── a56_temp_monitor.sh       # Real-time thermal monitoring
├── docs/                     # Runbooks (baseline, maintenance, recovery)
└── A56_Audit_*/              # ⚠️ GITIGNORED - timestamped output dirs with PII
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Run device audit | `galaxy_a56_audit_v2.sh` | Latest version, requires ADB |
| Monitor temperature | `a56_temp_monitor.sh` | Real-time thermal tracking |
| Longevity implementation | `docs/06_LONGEVITY_IMPLEMENTATION.md` | Full 7-year plan with ADB debloat |
| Device baseline specs | `docs/01_DEVICE_BASELINE.md` | Reference hardware/software |
| Maintenance schedule | `docs/03_MAINTENANCE_SCHEDULE.md` | Periodic checks |
| Disaster recovery | `docs/05_DISASTER_RECOVERY.md` | Brick/loss procedures |
| Privacy redaction | `docs/02_PRIVACY_REDACTION.md` | What to scrub before sharing |
| Toolbox setup | `docs/04_TOOLBOX_SETUP.md` | ADB/scrcpy installation |

## CONVENTIONS

- **ADB read-only**: Scripts use `adb shell` with read-only commands only. No `adb root`, no writes.
- **Timestamped outputs**: Audit creates `A56_Audit_YYYY-MM-DD_HH-MM-SS/` with numbered subdirs (01-09).
- **Bash safety**: Scripts use `set -euo pipefail`. Exit on any error.
- **Color output**: Scripts use ANSI colors for section headers.

## ANTI-PATTERNS (THIS PROJECT)

| Forbidden | Reason |
|-----------|--------|
| Rooting/unlocking bootloader | Breaks BRImo banking + Samsung Knox |
| Charging above 35°C | Battery degradation per project principles |
| Committing A56_Audit_* dirs | Contains PII (IMEI, serial, app lists) |
| USB debugging always-on | Security risk when not in use |
| Cloud-only backups | Project mandates local-first (adb backup, scrcpy) |

## CRITICAL WARNINGS

1. **2FA backup**: Before factory reset, export authenticator codes
2. **Temperature**: Never charge device above 35°C ambient
3. **80% charge limit**: Use Samsung battery protection feature
4. **ADB toggle**: Disable USB debugging when not actively using

## COMMANDS

```bash
# Run v2 audit (creates timestamped output dir)
./galaxy_a56_audit_v2.sh

# Preflight check
adb devices  # Must show device authorized

# View specific audit section
ls A56_Audit_*/01_identity/
```

## NOTES

- Output dirs (`A56_Audit_*`) are gitignored for privacy - never commit
- Scripts require Fedora with `adb` package installed
- Device must be connected via USB with debugging enabled
- v2 script adds radio/connectivity checks (section 07-09)
