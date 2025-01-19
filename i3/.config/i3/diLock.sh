#!/bin/bash
xset s off         # Disable the screensaver
xset -dpms         # Disable DPMS
xautolock -disable # Disable xautolock
notify-send "Screen lock and DPMS disabled"

