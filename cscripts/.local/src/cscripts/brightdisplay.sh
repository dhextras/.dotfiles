#!/bin/bash

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX_BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/max_brightness"
CACHE_FILE="/tmp/.last_brightness_percentage"
BAR_LENGTH=8

if [[ -f "$BRIGHTNESS_FILE" && -f "$MAX_BRIGHTNESS_FILE" ]]; then
    current=$(< "$BRIGHTNESS_FILE")
    max=$(< "$MAX_BRIGHTNESS_FILE")
    new_percentage=$(( (current * 100) / max ))

    # Read last percentage (default to current if not found)
    if [[ -f "$CACHE_FILE" ]]; then
        old_percentage=$(< "$CACHE_FILE")
    else
        old_percentage=$new_percentage
    fi

    # Save new percentage for next run
    echo "$new_percentage" > "$CACHE_FILE"

    # Determine direction of change
    if (( new_percentage > old_percentage )); then
        seq=$(seq $old_percentage $new_percentage)
    elif (( new_percentage < old_percentage )); then
        seq=$(seq $old_percentage -1 $new_percentage)
    else
        seq=$new_percentage
    fi

    for percent in $seq; do
        filled=$(( (percent * BAR_LENGTH) / 100 ))
        cursor_pos=$(( (percent * (BAR_LENGTH - 1)) / 100 ))

        bar=""
        for ((i = 0; i < BAR_LENGTH; i++)); do
            if [[ $i -eq $cursor_pos ]]; then
                bar+=""
            elif [[ $i -lt $filled ]]; then
                bar+="─"
            else
                bar+="─"
            fi
        done

        echo "%{T2}󰃠%{T-}  $bar ${percent}%"  # same icon every time
    done
else
    echo "%{T2}󰃠%{T-}  N/A"
fi
