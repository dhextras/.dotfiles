#!/bin/sh

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX_FILE="/sys/class/backlight/intel_backlight/max_brightness"
STEP=25

current=$(cat "$BRIGHTNESS_FILE")
max=$(cat "$MAX_FILE")
new=$(expr "$current" + "$STEP")
[ "$new" -gt "$max" ] && new=$max

echo "$new" | sudo tee "$BRIGHTNESS_FILE" > /dev/null
