#!/bin/bash

used_color="#9ece6a"

# Read memory info
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_avail))
usage=$((100 * mem_used / mem_total))

# Bar characters from small to full
blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
bar=""
filled=$((usage * 8 / 100))

if (( usage < 40 )); then
	used_color="#9ece6a"  # green
elif (( usage < 70 )); then
	used_color="#fab387"  # orange
elif (( usage < 85 )); then
	used_color="#f7768e"  # light red
else
	used_color="#bd2c40"  # alert red
fi

for i in "${!blocks[@]}"; do
  if (( i < filled )); then
    bar+="%{F$used_color}${blocks[i]}%{F-}"  # green
  else
    bar+="%{F#636578}${blocks[i]}%{F-}"  # gray
  fi
done

# Output with memory icon
echo "%{T3}󰍛%{T-}  $bar %{F$used_color}$usage%%{F-}"
