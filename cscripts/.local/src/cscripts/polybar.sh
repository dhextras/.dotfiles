#!/bin/sh

pulseaudio --check || pulseaudio --start
while [ ! -S "$XDG_RUNTIME_DIR/pulse/native" ]; do sleep 0.2; done

pkill -x polybar
polybar &
