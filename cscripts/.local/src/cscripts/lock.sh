#!/bin/bash

rice_count=0
rice_count=$((rice_count + $(xdotool search --name "DWM-Config" 2>/dev/null | wc -l)))
rice_count=$((rice_count + $(xdotool search --name "System-Info" 2>/dev/null | wc -l)))
rice_count=$((rice_count + $(xdotool search --name "cava" 2>/dev/null | wc -l)))
rice_count=$((rice_count + $(xdotool search --name "Matrix-Rain" 2>/dev/null | wc -l)))

if [ $rice_count -gt 3 ]; then
    xdotool key super+7
elif [ $rice_count -gt 0 ]; then
    xdotool key super+shift+alt+r
    sleep 0.7
    xdotool key super+shift+alt+r
    sleep 2.5
else
    xdotool key super+shift+alt+r
    sleep 2.5
fi


i3lock \
--insidever-color=1e1e2e44   \
--ringver-color=9ece6aff     \
--insidewrong-color=1e1e2e   \
--ringwrong-color=f38ba8     \
--inside-color=1e1e2e91      \
--ring-color=ffffffff        \
--color=1e1e2e22             \
--line-color=00000000        \
--separator-color=f9e2af     \
--verif-color=ffffff         \
--wrong-color=f38ba8         \
--time-color=7da6ff          \
--date-color=fab387         \
--bshl-color=f38ba8ff        \
--clock                      \
--indicator                  \
--time-str="%H:%M"           \
--date-str="%A %d %B"        \
--time-font="ComicShannsMono Nerd Font" \
--date-font="ComicShannsMono Nerd Font" \
--layout-font="ComicShannsMono Nerd Font" \
--verif-font="ComicShannsMono Nerd Font" \
--wrong-font="ComicShannsMono Nerd Font" \
--time-size=62               \
--date-size=28               \
--wrong-text="Fuck off!"     \
--verif-text="Checking.."    \
--noinput-text="No input"    \
--lock-text="Locked"         \
--lockfailed-text="Failed"   \
--time-pos="w/2:h/2-5"    \
--date-pos="w/2:h/2+35"    \
--radius=150                 \
--ring-width=6               \
--pass-media-keys            \
--pass-screen-keys           \
--pass-volume-keys
