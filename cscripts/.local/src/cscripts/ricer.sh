#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

zoom_out() {
    local level="$1"

    for i in $(seq 1 "$level"); do
        xdotool key ctrl+minus
    done
}

export -f zoom_out


install_rice() {
    sleep 0.1
    xdotool key super+shift+r
    xdotool key super+shift+g

    st -t "DWM-Config" -c ricerterm -e bash -c "
        xdotool key super+shift+o
        zoom_out 4
        if [ -f ~/.dotfiles/dwm/.local/src/dwm/config.h ]; then
            nvim +55 ~/.dotfiles/dwm/.local/src/dwm/config.h
        elif [ -f ~/.local/src/dwm/config.h ]; then
            nvim +55 ~/.local/src/dwm/config.h
        else
            echo 'DWM config not found!'
            exec bash
        fi
        exec bash
    " &

    sleep 0.5

    st -t "System-Info" -c ricerterm -e bash -c "
        xdotool key super+shift+o
        zoom_out 6
        btop
        exec bash
    " &

    sleep 0.5

    st -t "cava" -c ricerterm -e bash -c "
        xdotool key super+shift+o
        zoom_out 12
        ~/.local/src/cscripts/cava.sh 2>/dev/null || {
            echo -e '${RED}Cava not running - start some music!${NC}'
            exec bash
        }
    " &

    sleep 0.5

    st -t "Matrix-Rain" -c ricerterm -e bash -c "
        xdotool key super+shift+o
        zoom_out 8
        if command -v unimatrix > /dev/null; then
            unimatrix -s 95 -l cgkns
        else
            echo -e '${RED}unimatrix not found!${NC}'
            exec bash
        fi
    " &

    sleep 0.5
    xdotool key super+7
}

toggle_rice() {
    rice_windows=$(xdotool search --name "DWM-Config" 2>/dev/null)
    rice_windows="$rice_windows $(xdotool search --name "System-Info" 2>/dev/null)"
    rice_windows="$rice_windows $(xdotool search --name "cava" 2>/dev/null)"
    rice_windows="$rice_windows $(xdotool search --name "Matrix-Rain" 2>/dev/null)"

    rice_windows=$(echo $rice_windows | tr ' ' '\n' | grep -v '^$' | tr '\n' ' ')

    if [ -n "$rice_windows" ]; then
        for window_id in $rice_windows; do
            if [ -n "$window_id" ]; then
                xdotool windowclose "$window_id" 2>/dev/null
                sleep 0.1
            fi
        done
        sleep 0.3
        xdotool key super+equal
    else
        install_rice
    fi
}

if ! command -v xdotool > /dev/null; then
    echo -e "${RED}Error: xdotool not found!${NC}"
    exit 1
fi

if ! command -v st > /dev/null; then
    echo -e "${RED}Error: st (suckless terminal) not found!${NC}"
    exit 1
fi

toggle_rice
