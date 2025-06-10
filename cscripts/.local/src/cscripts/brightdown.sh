#!/bin/sh

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
STEP=25

current=$(cat "$BRIGHTNESS_FILE")
new=$(expr "$current" - "$STEP")
[ "$new" -lt 1 ] && new=1

echo "$new" | sudo tee "$BRIGHTNESS_FILE" > /dev/null
