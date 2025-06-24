#!/bin/bash

options="Lock Screen
Shutdown
Reboot
Suspend"

chosen=$(echo "$options" | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 450px;}' -font "ComicShannsMono Nerd Font 14")

case $chosen in
    "🔒 Lock Screen")
        ~/.local/src/cscripts/lock.sh &
        ;;
    "⏻ Shutdown")
        loginctl poweroff
        ;;
    "🔄 Reboot")
        loginctl reboot
        ;;
    "😴 Suspend")
        ~/.local/src/cscripts/lock.sh && loginctl suspend
        ;;
esac
