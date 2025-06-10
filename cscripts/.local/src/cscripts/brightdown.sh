#!/bin/sh

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
STEP=20

current=$(cat "$BRIGHTNESS_FILE")
new=$(expr "$current" - "$STEP")
[ "$new" -lt 0 ] && new=0

echo "$new" | sudo tee "$BRIGHTNESS_FILE" > /dev/null
