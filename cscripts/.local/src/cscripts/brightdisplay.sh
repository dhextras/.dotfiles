#!/bin/bash

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX_BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/max_brightness"

if [ -f "$BRIGHTNESS_FILE" ] && [ -f "$MAX_BRIGHTNESS_FILE" ]; then
	current=$(cat "$BRIGHTNESS_FILE")
	max=$(cat "$MAX_BRIGHTNESS_FILE")

    # Calculate percentage
    percentage=$(awk "BEGIN {printf \"%.0f\", ($current/$max)*100}")

    # Create visual bar (8 segments)
    bar_length=8
    filled=$(awk "BEGIN {printf \"%.0f\", ($percentage/100)*$bar_length}")

    bar=""
    for ((i=1; i<=bar_length; i++)); do
	    if [ $i -le $filled ]; then
		    bar="${bar}─"
	    else
		    bar="${bar}─"
	    fi
    done

    # Add cursor position indicator
    cursor_pos=$(awk "BEGIN {printf \"%.0f\", ($percentage/100)*($bar_length-1)}")
    if [ $cursor_pos -eq 0 ]; then
	    cursor_pos=0
    fi

    # Replace character at cursor position with indicator
    bar_with_cursor=""
    for ((i=0; i<bar_length; i++)); do
	    if [ $i -eq $cursor_pos ]; then
		    bar_with_cursor="${bar_with_cursor}"
	    else
		    if [ $i -lt $filled ]; then
			    bar_with_cursor="${bar_with_cursor}─"
		    else
			    bar_with_cursor="${bar_with_cursor}─"
		    fi
	    fi
    done

    echo "%{T2}󰃠%{T-}  ${bar_with_cursor} ${percentage}%"
else
	echo "%{T2}󰃠%{T-}  N/A"
fi
