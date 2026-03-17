#!/usr/bin/env bash
DEV="4-2"

timeout 5s lsblk /dev/sr0 >/dev/null 2>&1
if [ $? -eq 124 ]; then
  echo "Drive wedged, resetting USB"
  echo "$DEV" > /sys/bus/usb/drivers/usb/unbind
  sleep 2
  echo "$DEV" > /sys/bus/usb/drivers/usb/bind
fi
