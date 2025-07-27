#!/bin/bash

BINARY_PATH="/usr/bin/splyrics"

if [ ! -f "$BINARY_PATH" ]; then
    notify-send "splyrics" "Binary not found at $BINARY_PATH" -i audio-x-generic
    exit 1
fi

splyrics_windows=$(xdotool search --name "Splyrics" 2>/dev/null)
if [ -n "$splyrics_windows" ]; then
    exit 0
fi

if ! command -v playerctl &> /dev/null; then
    notify-send "splyrics" "playerctl not found. Install with: emerge media-sound/playerctl" -i dialog-error
    exit 1
fi

if ! playerctl --player=spotify status &> /dev/null; then
    notify-send "splyrics" "Spotify not running. Start Spotify first."
    exit 1
fi

SCREEN_WIDTH=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f1)
SCREEN_HEIGHT=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f2)

WINDOW_WIDTH=$((SCREEN_WIDTH / 2))
WINDOW_HEIGHT=$((SCREEN_HEIGHT * 60 / 100))
WINDOW_X=$((SCREEN_WIDTH / 2))
WINDOW_Y=50


echo $SCREEN_WIDTH $WINDOW_WIDTH $SCREEN_HEIGHT $WINDOW_HEIGHT
st -c "floatterm" \
   -t Splyrics \
   -e bash -c "splyrics" &

sleep 0.5
WID=$(xdotool search --class "$WINDOW_CLASS" | tail -1)
if [ -n "$WID" ]; then
    xdotool windowstate --add STICKY "$WID"
    xdotool windowstate --add ABOVE "$WID"
fi
