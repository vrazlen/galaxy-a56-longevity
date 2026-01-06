#!/bin/bash
# Galaxy A56 Temperature Monitor
# Usage: ./a56_temp_monitor.sh [interval_seconds]
# Requires: ADB connected device

set -euo pipefail

INTERVAL=${1:-10}

# Check ADB connection
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo "Error: No ADB device connected or not authorized"
    echo "Connect device and enable USB debugging"
    exit 1
fi

echo "=== Galaxy A56 Temperature Monitor ==="
echo "Interval: ${INTERVAL}s (Ctrl+C to stop)"
echo ""
echo "Timestamp,Temp(°C),Level(%),Status,Health"
echo "----------------------------------------"

while true; do
    DATA=$(adb shell dumpsys battery 2>/dev/null)
    
    TEMP=$(echo "$DATA" | grep "temperature:" | awk '{printf "%.1f", $2/10}')
    LEVEL=$(echo "$DATA" | grep "level:" | head -1 | awk '{print $2}')
    STATUS=$(echo "$DATA" | grep "status:" | awk '{print $2}')
    HEALTH=$(echo "$DATA" | grep "health:" | awk '{print $2}')
    
    # Status codes: 1=unknown, 2=charging, 3=discharging, 4=not charging, 5=full
    case $STATUS in
        2) STATUS_STR="Charging" ;;
        3) STATUS_STR="Discharging" ;;
        4) STATUS_STR="Not charging" ;;
        5) STATUS_STR="Full" ;;
        *) STATUS_STR="Unknown" ;;
    esac
    
    # Health codes: 1=unknown, 2=good, 3=overheat, 4=dead, 5=over voltage, 6=failure, 7=cold
    case $HEALTH in
        2) HEALTH_STR="Good" ;;
        3) HEALTH_STR="OVERHEAT" ;;
        7) HEALTH_STR="Cold" ;;
        *) HEALTH_STR="Check" ;;
    esac
    
    # Color output based on temperature
    if (( $(echo "$TEMP >= 42" | bc -l) )); then
        COLOR="\033[0;31m"  # Red
        ALERT="🔴 CRITICAL"
    elif (( $(echo "$TEMP >= 40" | bc -l) )); then
        COLOR="\033[0;33m"  # Yellow
        ALERT="🔶 HIGH"
    elif (( $(echo "$TEMP >= 35" | bc -l) )); then
        COLOR="\033[0;36m"  # Cyan
        ALERT="⚠️  WARM"
    else
        COLOR="\033[0;32m"  # Green
        ALERT="✅ SAFE"
    fi
    RESET="\033[0m"
    
    echo -e "${COLOR}$(date '+%H:%M:%S') | ${TEMP}°C | ${LEVEL}% | ${STATUS_STR} | ${HEALTH_STR} | ${ALERT}${RESET}"
    
    # Critical warning
    if (( $(echo "$TEMP >= 42" | bc -l) )); then
        echo -e "${COLOR}>>> STOP CHARGING - Battery temperature too high <<<${RESET}"
    fi
    
    sleep "$INTERVAL"
done
