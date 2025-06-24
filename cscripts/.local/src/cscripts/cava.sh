#!/bin/bash

INTERNAL_SOURCE="pulse"
MIC_SOURCE="alsa_input.pci-0000_00_1f.3.analog-stereo"
CHECK_INTERVAL=2

cleanup() {
    pkill -P $$ cava 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

check_internal_audio() {
    if command -v pactl >/dev/null 2>&1; then
        local volume=$(pactl list sinks | grep -A 15 "State: RUNNING" | grep "Volume:" | head -1 | grep -o '[0-9]*%' | head -1 | tr -d '%')
        if [ -n "$volume" ] && [ "$volume" -gt 0 ]; then
            timeout 1 pactl subscribe | grep -q "sink" && return 0
        fi
    fi

    if pgrep -f "(spotify|mpv|vlc|firefox|chromium|discord)" >/dev/null; then
        if command -v amixer >/dev/null 2>&1; then
            local master_vol=$(amixer get Master | grep -o '[0-9]*%' | head -1 | tr -d '%')
            [ "$master_vol" -gt 5 ] && return 0
        fi
        return 0
    fi

    return 1
}

CURRENT_MODE=""
if check_internal_audio; then
    if [ "$CURRENT_MODE" != "internal" ]; then
        pkill -P $$ cava 2>/dev/null
        sleep 0.5
        cava
        CAVA_PID=$!
        CURRENT_MODE="internal"
        fi
    else
    if [ "$CURRENT_MODE" != "mic" ]; then
        pkill -P $$ cava 2>/dev/null
        sleep 0.1
        cava -p <(sed "s/^source =.*/source = $MIC_SOURCE/" ~/.config/cava/config)
        CAVA_PID=$!
        CURRENT_MODE="mic"
    fi
fi
