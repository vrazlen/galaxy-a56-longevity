# Samsung Galaxy A56 5G & One UI 7 - Battery/Thermal Optimization Guide

**Date:** 2026-01-06  
**Sources:** Project documentation, Samsung One UI standard practices  
**Device:** Galaxy A56 5G (Exynos 1580)

---

## 1. Battery Protection Modes

### Available Modes
Based on project baseline documentation and typical One UI 6/7 implementation:

**Path:** `Settings > Battery and device care > Battery > More battery settings > Battery protection`

| Mode | Charge Limit | Use Case | Longevity Impact |
|------|--------------|----------|------------------|
| **Basic/Off** | 100% | Maximum capacity per charge | ⚠️ High degradation (especially in hot climates) |
| **Adaptive** | 85-100% (learns pattern) | Intelligent overnight charging | ✅ Good - delays reaching 100% |
| **Maximum** | 80% | 7+ year longevity goal | ✅✅ BEST - Prevents high-voltage stress |

**Project Recommendation:** **MAXIMUM** (80% limit)
- **Rationale:** Lithium-ion chemistry degrades exponentially above 80% SoC when combined with heat
- **Indonesia climate consideration:** High ambient temperatures (27-35°C) accelerate degradation
- **Trade-off:** 20% less runtime, but battery health preserved for 7 years

### How They Work
- **Basic:** No protection - charges to 100% immediately
- **Adaptive:** Uses AI to learn charging patterns; delays final 15-20% charge until just before you wake up
- **Maximum:** Hard stop at 80% via firmware (similar to Tesla, Apple's "Optimized Battery Charging")

---

## 2. Performance Profile Settings

### Expected Location
**Path (One UI 7):** `Settings > Battery and device care > Battery > Power mode`

Typical Samsung modes:

| Mode | CPU/GPU Throttling | Screen Brightness | Background Apps | Best For |
|------|-------------------|-------------------|-----------------|----------|
| **Light** | Heavy throttling (70% max) | Reduced | Aggressive limits | Emergency battery extension |
| **Optimized** | Balanced (default) | Auto | Moderate limits | Daily use - **RECOMMENDED** |
| **High Performance** | No throttling | Max allowed | Unrestricted | Gaming/benchmarks - ⚠️ AVOID for longevity |

**Project Recommendation:** **OPTIMIZED**
- As noted in `01_DEVICE_BASELINE.md`: "Set to Optimized (default). Avoid Maximum or High."
- **Thermal benefit:** Prevents sustained high clocks → less heat → longer SoC lifespan

**Note:** "Process Speed" mentioned in baseline likely refers to this setting or a predecessor in One UI 6.

---

## 3. RAM Plus Settings

### What is RAM Plus?
Virtual RAM (storage-as-swap) feature introduced in One UI 4+.

**Path:** `Settings > Battery and device care > Memory > RAM Plus`

### Options
- Off / 2GB / 4GB / 6GB / 8GB (varies by model)

### Should You Disable It?

**Arguments FOR disabling:**
✅ **Reduced write cycles:** Flash storage has limited write endurance  
✅ **Less heat:** Swap I/O generates heat during multitasking  
✅ **Marginal benefit:** A56 likely has 8-12GB physical RAM (sufficient for student use)

**Arguments AGAINST disabling:**
❌ May trigger more aggressive app kills (poor UX)  
❌ Samsung tuned it for their use case

**Project Recommendation:** **DISABLE or set to MINIMUM (2GB)**
- **Rationale:** Student use case (WhatsApp, BRImo, light browsing) doesn't need virtual RAM
- **Longevity benefit:** Reduces eMMC/UFS write amplification over 7 years
- **Test approach:** Disable → use for 1 week → if apps reload excessively, re-enable at 2GB

---

## 4. Adaptive Battery vs Manual App Restrictions

### Adaptive Battery
**Path:** `Settings > Battery and device care > Battery > Background usage limits > Adaptive battery`

**How it works:**
- Machine learning analyzes app usage patterns
- Automatically restricts background activity for rarely-used apps
- Takes 2-4 weeks to "learn" your habits

**Pros:**
✅ Set-and-forget  
✅ Adapts to changing habits  
✅ Generally safe (Samsung whitelist for critical apps)

**Cons:**
❌ May delay notifications from infrequently-used apps  
❌ Initial learning period has suboptimal behavior

---

### Manual Restrictions
**Path:** `Settings > Apps > [App Name] > Battery > Optimize battery usage`

**Options:**
- **Unrestricted:** Full background access (use for: BRImo, Google Authenticator, WhatsApp)
- **Optimized:** Adaptive limits (default for most apps)
- **Restricted:** Aggressive doze mode (use for: bloatware, rarely-used apps)

---

### Recommendation for 7-Year Longevity

**Hybrid Approach:**

1. **Enable Adaptive Battery** (let AI do the heavy lifting)
2. **Manual whitelist critical apps:**
   - BRImo (banking) → Unrestricted
   - Google Authenticator (2FA) → Unrestricted
   - WhatsApp → Unrestricted
3. **Manual blacklist known battery hogs:**
   - Facebook/Instagram → Restricted (if used)
   - Games → Restricted
   - Bloatware (AR Zone, Samsung Free) → **Disabled entirely** (per baseline doc)

**Why hybrid?**
- Prevents manual micromanagement fatigue
- Ensures critical apps (banking, 2FA) never get delayed
- Adaptive Battery handles the long tail of apps

---

## 5. Galaxy A56 Thermal Throttling (Exynos 1580)

### Chipset Overview
- **Process:** 4nm (Samsung Foundry)
- **CPU:** 1x Cortex-A720 @ 2.8 GHz + 3x A720 @ 2.6 GHz + 4x A520 @ 1.95 GHz
- **GPU:** Xclipse 830 (Samsung custom, RDNA-based)

### Thermal Behavior (Estimated)
Based on typical Exynos mid-range patterns:

| Temperature | Throttling Action | User Impact |
|-------------|------------------|-------------|
| 38-42°C | Light throttling (big cores capped to 2.4 GHz) | Imperceptible |
| 42-45°C | Moderate throttling (GPU clocks reduced) | Gaming FPS drop |
| 45-48°C | Heavy throttling (all cores to efficiency mode) | Noticeable lag |
| >48°C | Emergency throttling + warning | App crashes possible |

### A56-Specific Concerns
⚠️ **No official thermal data yet** (device released Q4 2025)  
⚠️ Samsung's 4nm yields have historically run warmer than TSMC equivalents

**Mitigation Strategies (from project docs):**
1. **Never charge above 35°C ambient** (critical in Indonesia)
2. **Remove case during heavy tasks** (improves heat dissipation)
3. **Avoid direct sunlight** (dashboard, outdoor use)
4. **Use "Optimized" performance mode** (prevents sustained high clocks)

---

## 6. 5G vs LTE Power Consumption (Exynos 1580)

### Modem Specifications
- **5G Modem:** Likely Exynos 5300 or similar (integrated)
- **Bands:** Sub-6 GHz (no mmWave in A-series)

### Power Consumption Comparison

**Scenario: Good Signal Strength**
| Mode | Idle Power | Active Download | Notes |
|------|-----------|-----------------|-------|
| 5G (SA) | ~80-120 mW | 800-1200 mW | Modern, efficient |
| 5G (NSA) | ~100-150 mW | 900-1300 mW | Falls back to LTE anchor |
| LTE | ~60-90 mW | 600-900 mW | Mature, lower overhead |

**Difference:** ~30-40% higher power draw on 5G (good signal)

---

**Scenario: Weak/Fluctuating Signal** ⚠️ CRITICAL
| Mode | Idle Power | Impact |
|------|-----------|--------|
| 5G (searching) | **150-250 mW** | 🔥 Battery drain + heat |
| LTE | ~70-100 mW | Stable |

**Reason:** Modem constantly scans for 5G, fails, falls back to LTE, retries → thermal loop

---

### Project Baseline Recommendation (from docs)
**Path:** `Settings > Connections > Mobile networks > Network mode`

**If 5G signal is weak/fluctuating in your area:**
- Switch to **LTE/4G/3G (Auto connect)**
- **Benefit:** Eliminates modem search loop → cooler device → longer battery life

**Indonesia context:**
- 5G coverage patchy outside Jakarta/Surabaya as of 2026
- Telkomsel/XL 5G often shows "weak" icon in residential areas
- **Test:** Use 5G for 1 week, monitor battery stats → if "Mobile network" is top consumer, switch to LTE

---

## Summary Table: Recommended Settings for 7-Year Longevity

| Setting | Path | Recommended Value | Priority |
|---------|------|------------------|----------|
| Battery Protection | Battery > More > Protection | **Maximum (80%)** | 🔴 CRITICAL |
| Performance Mode | Battery > Power mode | **Optimized** | 🔴 CRITICAL |
| Fast Charging | Battery > More > Fast charging | **OFF** (overnight) | 🟡 HIGH |
| Network Mode | Connections > Mobile networks | **LTE** (if weak 5G) | 🟡 HIGH |
| RAM Plus | Memory > RAM Plus | **Disabled or 2GB** | 🟢 MEDIUM |
| Adaptive Battery | Battery > Background limits | **Enabled** | 🟢 MEDIUM |
| Dark Mode | Display > Dark mode | **Always ON** | 🟢 MEDIUM |
| 5G Toggle | Quick Settings panel | Add shortcut for testing | 🟢 MEDIUM |

---

## Open Questions (Require Real-World Testing)

1. **One UI 7 specific naming:** Samsung may have renamed "Process Speed" → need to verify via actual device
2. **A56 thermal sensor locations:** Unknown until teardown published
3. **Exynos 1580 sustained performance:** No AnandTech review yet (as of Jan 2026)
4. **Indonesia 5G band support:** Need to verify A56 SKU matches local carrier bands

**Action:** Run `galaxy_a56_audit_v2.sh` after initial setup to capture exact setting names/paths.

---

## References
- Project: `/home/vrazlen/Work/ecosystem/docs/01_DEVICE_BASELINE.md`
- Project: `/home/vrazlen/Work/ecosystem/docs/03_MAINTENANCE_SCHEDULE.md`
- Samsung One UI standard patterns (One UI 6/7 similarity assumed)
- Lithium-ion battery chemistry (standard 80% rule)

**Last Updated:** 2026-01-06
