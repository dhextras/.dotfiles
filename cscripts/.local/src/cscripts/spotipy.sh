#!/bin/bash

# Prioritize Spotify
if playerctl --player=spotify status &>/dev/null; then
    status=$(playerctl --player=spotify status)
    if [[ $status == "Playing" || $status == "Paused" ]]; then
        artist=$(playerctl --player=spotify metadata artist)
        title=$(playerctl --player=spotify metadata title)
        echo "$artist - $title"
        exit 0
    fi
fi

echo "No Myusik"
