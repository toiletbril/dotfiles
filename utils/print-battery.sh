#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/"
BATTERY_DEVICE_DIR="$(ls /sys/class/power_supply | grep "BAT" | head -n 1)"
BATTERY_DEVICE="$BATTERY_PATH/$BATTERY_DEVICE_DIR"
BATTERY_PERCENTAGE=$(cat $BATTERY_DEVICE/capacity)

while getopts ":std" opt; do
  case ${opt} in
    s)
      BATTERY_STATUS=", $(cat $BATTERY_DEVICE/status)"
      ;;
    t)
      CURRENT_TIME=", $(date +%R)"
      ;;
    d)
      CURRENT_DATE=", $(date +%x)"
      ;;
    *)
      echo "Invalid option '-$OPTARG'. Available options: [-dst]" 1>&2
      exit 1
      ;;
  esac
done

echo "$BATTERY_PERCENTAGE%$BATTERY_STATUS$CURRENT_DATE$CURRENT_TIME"
