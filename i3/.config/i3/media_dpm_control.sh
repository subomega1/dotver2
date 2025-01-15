#!/bin/bash

# Script: autolock_dpms.sh
# Description: Prevents screen from locking or sleeping when audio is playing, and controls DPMS and autolock behavior.
# Requirements: xautolock, xset, playerctl, and i3lock (or another lock command)

# === Configuration Section ===

LOCK_TIME=300            # Time in seconds before locking the screen (e.g., 5 minutes)
LOCK_CMD="i3lock"        # Command to lock the screen
DPMS_TIMEOUT=600         # DPMS timeout in seconds (e.g., 10 minutes)

# === Function Definitions ===

# Enable DPMS with specified timeout
enable_dpms() {
  xset dpms $DPMS_TIMEOUT $DPMS_TIMEOUT $DPMS_TIMEOUT
}

# Disable DPMS (prevent screen from turning off)
disable_dpms() {
  xset -dpms
}

# Check if media is playing and conditionally lock the screen
lock_if_not_playing() {
  if [ "$(playerctl status 2>/dev/null)" != "Playing" ]; then
    enable_dpms  # Ensure DPMS is enabled when not playing
    $LOCK_CMD
  else
    disable_dpms  # Disable DPMS to prevent sleep when playing
  fi
}

# Set up xautolock with custom locker command
configure_xautolock() {
  xautolock -time $((LOCK_TIME / 60)) -locker "lock_if_not_playing" &

  # Notify user and pause media 10 seconds before locking
  xautolock -time $((LOCK_TIME / 60)) -notify 10 -notifier "playerctl pause" &
}

# === Main Execution Section ===

enable_dpms  # Start with DPMS enabled
configure_xautolock  # Set up xautolock with custom lock behavior

echo "Autolock and DPMS setup with playerctl control is active."
