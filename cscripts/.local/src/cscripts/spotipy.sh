#!/bin/bash

MAX_LEN=36
SCROLL_DELAY=0.2
ICON_PLAY="%{T2}%{T-} "
ICON_PAUSE="%{T2}%{T-}  "
ICON_NOMUSIC="%{T2}󰟎%{T-}  "
SEPARATOR="   󰎇󰎇󰎇   "

repeat_text() {
	local text="$1"
	local times="$2"
	local result="$text"
	for ((i=1; i<times; i++)); do
		result+="$SEPARATOR$text"
	done
	echo "$result"
}

scroll_text() {
	local icon="$1"
	local text="$2"
	local max="$3"
	local delay="$4"
	local padding="   "
	local display_text="${padding}${text}${padding}"
	local len=${#display_text}

	while true; do
		for ((i=0; i<len; i++)); do
			chunk="${display_text:i:max}"
			(( ${#chunk} < max )) && chunk+="${display_text:0:max - ${#chunk}}"
			echo "$icon$chunk"
			sleep "$delay"
		done
	done
}

prev_song=""
prev_status=""
scroll_pid=0

while true; do
	if playerctl --player=spotify status &>/dev/null; then
		status=$(playerctl --player=spotify status)
		if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
			artist=$(playerctl --player=spotify metadata artist)
			title=$(playerctl --player=spotify metadata title)
			nowplaying="$artist - $title"
			icon="$([[ $status == Playing ]] && echo "$ICON_PLAY" || echo "$ICON_PAUSE")"

			if [[ "$status" == "Paused" ]]; then
				if [[ "$nowplaying" != "$prev_song" || "$status" != "$prev_status" ]]; then
					prev_song="$nowplaying"
					prev_status="$status"
					[[ $scroll_pid -ne 0 ]] && kill $scroll_pid 2>/dev/null && wait $scroll_pid 2>/dev/null
					scroll_pid=0

					static_text=$(repeat_text "$nowplaying" 3)
					display_text="${static_text:0:MAX_LEN-3}..."
					echo "$icon$display_text"
				fi
				sleep 1
				continue
			fi

			if [[ "$nowplaying" != "$prev_song" || "$status" != "$prev_status" ]]; then
				prev_song="$nowplaying"
				prev_status="$status"
				[[ $scroll_pid -ne 0 ]] && kill $scroll_pid 2>/dev/null && wait $scroll_pid 2>/dev/null
				repeated_text=$(repeat_text "$nowplaying" 10)
				scroll_text "$icon" "$repeated_text" "$MAX_LEN" "$SCROLL_DELAY" &
				scroll_pid=$!
			fi

			sleep 0.2
		else
			prev_song=""
			prev_status=""
			[[ $scroll_pid -ne 0 ]] && kill $scroll_pid 2>/dev/null && wait $scroll_pid 2>/dev/null
			scroll_pid=0

			text="No Myusik"
			icon="$ICON_NOMUSIC"
			repeated_text=$(repeat_text "$text" 5)
			scroll_text "$icon" "$repeated_text" "$MAX_LEN" "$SCROLL_DELAY" &
			scroll_pid=$!
			sleep 1
		fi
	else
		prev_song=""
		prev_status=""
		[[ $scroll_pid -ne 0 ]] && kill $scroll_pid 2>/dev/null && wait $scroll_pid 2>/dev/null
		scroll_pid=0

		text="No Myusik"
		icon="$ICON_NOMUSIC"
		static_text=$(repeat_text "$text" 5)
		display_text="${static_text:0:MAX_LEN-3}..."
		echo "$icon$display_text"

		# scroll_text "$icon" "$repeated_text" "$MAX_LEN" "$SCROLL_DELAY" &
		# scroll_pid=$!
		sleep 1
	fi
done

