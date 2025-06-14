#!/bin/bash

used_color="#9ece6a"
unused_color="#636578"

# Read initial CPU stats
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
prev_idle=$idle

sleep 0.5

# Read new CPU stats
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))

diff_total=$((total - prev_total))
diff_idle=$((idle - prev_idle))

usage=$((100 * (diff_total - diff_idle) / diff_total))

if (( usage < 40 )); then
	used_color="#9ece6a"  # green
elif (( usage < 70 )); then
	used_color="#fab387"  # orange
elif (( usage < 85 )); then
	used_color="#f7768e"  # light red
else
	used_color="#bd2c40"  # alert red
fi

bars=$((usage / 9)) # NOTE: Future dumb me don't fucking change this to 10, 9 works so stfu
bar=""
for i in $(seq 1 10); do
  if [ "$i" -lt "$bars" ]; then
    bar+="%{F$used_color}=%{F-}"  # filled bar in color
  elif [ "$i" -eq "$bars" ]; then
    bar+="%{F$used_color}/%{F-}"  # peak slash in color
  else
    bar+="%{F$unused_color}=%{F-}"  # empty bar in gray
  fi
done

echo "%{T3}󰻠%{T-}  $bar %{F$used_color}$usage%%{F-}"

