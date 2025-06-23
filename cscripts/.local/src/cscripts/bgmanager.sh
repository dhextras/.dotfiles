#!/bin/bash

CONFIG_DIR="$HOME/.config/bg-manager"
WALLPAPER_DIR="$HOME/Desktop wallpaper"
STATE_FILE="$CONFIG_DIR/state"
CURRENT_WP_FILE="$CONFIG_DIR/current_wallpaper"
CYCLE_INTERVAL=60
IGNORE_CLASSES="polybar,Polybar,flameshot,Flameshot"

mkdir -p "$CONFIG_DIR"

if [[ ! -f "$STATE_FILE" ]]; then
    echo "cycling=false" > "$STATE_FILE"
fi

has_windows() {
    local windows
    class=$(xdotool getactivewindow getwindowclassname 2>/dev/null)
    if [[ ",$IGNORE_CLASSES," == *",$class,"* ]]; then
        return 1
    fi

    return 1
}

set_wallpaper() {
    local image="$1"
    feh --bg-max --image-bg "#2d2d30" "$image"
    echo "$image" > "$CURRENT_WP_FILE"
}

get_random_wallpaper() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) | shuf -n 1
}

cycle_wallpapers() {
    local random_wp
    random_wp=$(get_random_wallpaper)

    if [[ -n "$random_wp" ]]; then
        set_wallpaper "$random_wp"
    fi
}

show_wallpaper_selector() {
    local images_dir="$WALLPAPER_DIR"

    local selected
    selected=$(find "$images_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) | \
           fzf --preview 'chafa --size $(tput cols)x$(tput lines) --fit-width {}' \
               --preview-window up:80% \
               --height 100% \
               --border)

    if [[ -n "$selected" ]]; then
        set_wallpaper "$selected"
        sed -i 's/cycling=true/cycling=false/' "$STATE_FILE"
        pkill -f "bgmanager.*daemon" 2>/dev/null || true
        notify-send "Selected: $(basename "$selected")"
    fi
}

toggle_cycling() {
    local current_state
    current_state=$(grep "cycling=" "$STATE_FILE" | cut -d'=' -f2)

    if [[ "$current_state" == "true" ]]; then
        sed -i 's/cycling=true/cycling=false/' "$STATE_FILE"
        pkill -f "bgmanager.*daemon" 2>/dev/null || true
        notify-send "Wallpaper cycling stopped"
    else
        sed -i 's/cycling=false/cycling=true/' "$STATE_FILE"
        "$0" start_daemon &
        notify-send "Wallpaper cycling started (every ${CYCLE_INTERVAL}s)"
    fi
}

start_daemon() {
    while true; do
        local cycling_state
        cycling_state=$(grep "cycling=" "$STATE_FILE" | cut -d'=' -f2)

        if [[ "$cycling_state" != "true" ]]; then
            echo "Cycling disabled, daemon exiting"
            break
        fi

        cycle_wallpapers
        sleep "$CYCLE_INTERVAL"
    done
}

init() {
    if [[ ! -f "$CURRENT_WP_FILE" ]] || [[ ! -s "$CURRENT_WP_FILE" ]]; then
        local random_wp
        random_wp=$(get_random_wallpaper)
        if [[ -n "$random_wp" ]]; then
            set_wallpaper "$random_wp"
        fi
    else
        local current_wp
        current_wp=$(cat "$CURRENT_WP_FILE")
        if [[ -f "$current_wp" ]]; then
            feh --bg-max --image-bg "#2d2d30"  "$current_wp"
        fi
    fi
}

case "${1:-}" in
    "start_daemon")
        start_daemon
        ;;
    "cycle")
        toggle_cycling
        ;;
    "select")
        show_wallpaper_selector
        ;;
    "random")
        cycle_wallpapers
        ;;
    "init")
        init
        ;;
    *)
        echo "Usage: $0 {cycle|select|random|init}"
        echo ""
        echo "Commands:"
        echo "  cycle        - Toggle auto-cycling"
        echo "  select       - Show wallpaper selector"
        echo "  random       - Set random wallpaper"
        echo "  init         - Initialize on startup"
        ;;
esac
