#!/bin/bash

MAX_LEN=36
SCROLL_DELAY=0.35
SEPARATOR="   󰎇󰎇󰎇"

declare -A colors=(
	["primary"]="#cdd6f4"
	["disabled"]="#636578"
	["blue"]="#89b4fa"
	["orange"]="#fab387"
	["green"]="#a6e3a1"
	["purple"]="#cba6f7"
)

ICON_PLAY="%{F${colors[primary]}}%{T2}%{T-}%{F-} "
ICON_PAUSE="%{F${colors[primary]}}%{T2}%{T-}%{F-}  "
ICON_NOMUSIC="%{F${colors[disabled]}}%{T2}󰟎%{T-}%{F-}  "

repeat_text() {
	local text="$1"
	local times="$2"
	local result="$text"
	for ((i=1; i<times; i++)); do
		result+="$SEPARATOR   $text"
	done
	result+="$SEPARATOR"
	echo "$result"
}

colorize_text() {
	local artist="$1"
	local title="$2"
	local colored_artist="%{F${colors[green]}}$artist%{F-}"
	local colored_title="%{F${colors[green]}}$title%{F-}"
	echo "$colored_artist %{F${colors[blue]}}- %{F-}$colored_title"
}

get_display_length() {
	local text="$1"
	local icon="$2"
	local max_len="$3"

	local icon_visible=$(echo "$icon" | sed 's/%{[^}]*}//g')
	local text_visible=$(echo "$text" | sed 's/%{[^}]*}//g')
	local available_space=$((max_len - ${#icon_visible} - 4)) # NOTE: 4 for the ...

		if [[ ${#text_visible} -le $available_space ]]; then
			echo "$text"
		else
			local result=""
			local visible_count=0
			local i=0

			while [[ $i -lt ${#text} && $visible_count -lt $available_space ]]; do
				local char="${text:$i:1}"
				if [[ "$char" == "%" && "${text:$i:2}" == "%{" ]]; then
					local color_code=""
					while [[ $i -lt ${#text} && "${text:$i:1}" != "}" ]]; do
						color_code="$color_code${text:$i:1}"
						((i++))
					done
					if [[ $i -lt ${#text} ]]; then
						color_code="$color_code${text:$i:1}"
						((i++))
					fi
					result="$result$color_code"
				else
					result="$result$char"
					((visible_count++))
					((i++))
				fi
			done
			echo "$result ..."
		fi
	}

get_visible_length() {
	local text="$1"
	local stripped=$(echo "$text" | sed 's/%{[^}]*}//g')
	echo ${#stripped}
	}

scroll_text() {
	local icon="$1"
	local text="$2"
	local max="$3"
	local delay="$4"
	local padding="   "
	local display_text="${padding}${text}${padding}"

	local icon_visible=$(echo "$icon" | sed 's/%{[^}]*}//g')
	local visible_max=$((max - ${#icon_visible}))
		local display_visible=$(get_visible_length "$display_text")

		if [[ $display_visible -le $visible_max ]]; then
			echo "$icon$display_text"
			return
		fi

		local text_array=()
		local i=0
		local current_char=""

		while [[ $i -lt ${#display_text} ]]; do
			current_char="${display_text:$i:1}"
			if [[ "$current_char" == "%" && "${display_text:$i:2}" == "%{" ]]; then
				color_code=""
				while [[ $i -lt ${#display_text} && "${display_text:$i:1}" != "}" ]]; do
					color_code="$color_code${display_text:$i:1}"
					((i++))
				done
				if [[ $i -lt ${#display_text} ]]; then
					color_code="$color_code${display_text:$i:1}"
					((i++))
				fi
				text_array+=("$color_code")
			else
				text_array+=("$current_char")
				((i++))
			fi
		done

		# echo "=== text_array contents ==="
		# for idx in "${!text_array[@]}"; do
		#   			printf "[%d]: '%s'\n" "$idx" "${text_array[$idx]}"
		# done
		# echo "==========================="

		local pos=0
		local stripped_formatters=""
		while true; do
			local display=""
			local visible_count=0
			local array_pos=$pos

			while [[ $visible_count -lt $visible_max ]]; do
				if [[ $array_pos -ge ${#text_array[@]} ]]; then
					array_pos=0
				fi

				local element="${text_array[$array_pos]}"
				display="$display$element"

				if [[ ! "$element" =~ ^%\{.*\}$ ]]; then
					((visible_count++))
				fi

				((array_pos++))
			done

			echo "$icon$stripped_formatters$display"
			sleep "$delay"

			next_pos=$((pos + 1))

			while [[ $next_pos -lt ${#text_array[@]} && "${text_array[$next_pos]}" =~ ^%\{.*\}$ ]]; do
				stripped_formatters="${text_array[$next_pos]}"
				((next_pos++))
			done

			if [[ $next_pos -ge ${#text_array[@]} ]]; then
				next_pos=0
				stripped_formatters=""
				while [[ $next_pos -lt ${#text_array[@]} && "${text_array[$next_pos]}" =~ ^%\{.*\}$ ]]; do
					stripped_formatters+="${text_array[$next_pos]}"
					((next_pos++))
				done
			fi

			pos=$next_pos
		done
	}

prev_song=""
prev_status=""
scroll_pid=0

trap 'kill $scroll_pid 2>/dev/null; exit' INT TERM

while true; do
	if playerctl --player=spotify status &>/dev/null; then
		status=$(playerctl --player=spotify status)
		if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
			artist=$(playerctl --player=spotify metadata artist)
			title=$(playerctl --player=spotify metadata title)
			nowplaying=$(colorize_text "$artist" "$title")
			icon="$([[ $status == Playing ]] && echo "$ICON_PLAY" || echo "$ICON_PAUSE")"

			if [[ "$status" == "Paused" ]]; then
				if [[ "$artist - $title" != "$prev_song" || "$status" != "$prev_status" ]]; then
					prev_song="$artist - $title"
					prev_status="$status"
					[[ $scroll_pid -ne 0 ]] && kill $scroll_pid 2>/dev/null && wait $scroll_pid 2>/dev/null
					scroll_pid=0
					static_text=$(repeat_text "$nowplaying" 3)
					display_text=$(get_display_length "$static_text" "$icon" "$MAX_LEN")
					echo "$icon$display_text"
				fi
				sleep 0.2
				continue
			fi

			if [[ "$artist - $title" != "$prev_song" || "$status" != "$prev_status" ]]; then
				prev_song="$artist - $title"
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
			text="%{F${colors[purple]}}No Myusik%{F-}"
			icon="$ICON_NOMUSIC"
			repeated_text=$(repeat_text "$text" 5)
			scroll_text "$icon" "$repeated_text" "$MAX_LEN" "$SCROLL_DELAY" &
			scroll_pid=$!
			sleep 0.2
		fi
	else
		prev_song=""
		prev_status=""
		[[ $scroll_pid -ne 0 ]] && kill $scroll_pid 2>/dev/null && wait $scroll_pid 2>/dev/null
		scroll_pid=0
		text="%{F${colors[purple]}}No Myusik%{F-}"
		icon="$ICON_NOMUSIC"
		static_text=$(repeat_text "$text" 5)
		display_text=$(get_display_length "$static_text" "$icon" "$MAX_LEN")
		echo "$icon$display_text"
		sleep 0.2
	fi
done
