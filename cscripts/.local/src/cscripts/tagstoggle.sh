#!/bin/bash

STATE_FILE="/tmp/polybar_tags_state"

# Default state
[ ! -f "$STATE_FILE" ] && echo "active" > "$STATE_FILE"

STATE=$(cat "$STATE_FILE")

if [ "$STATE" = "active" ]; then
    # Show all tags
    polybar-msg action tagsbar hook 2
    echo "all" > "$STATE_FILE"
    polybar-msg cmd restart  # force reload to apply
else
    # Show only active
    polybar-msg action tagsbar hook 1
    echo "active" > "$STATE_FILE"
    polybar-msg cmd restart
fi

