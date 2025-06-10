#!/bin/bash

FLAG="$HOME/.cache/polybar_show_all_tags"
[[ ! -f "$FLAG" ]] && echo "0" > "$FLAG"

mode=$(cat "$FLAG")

if [ "$mode" = "1" ]; then
  sed -i 's/modules-center =.*$/modules-center = tagsbar_all/' ~/.dotfiles/polybar/.config/polybar/config.ini
else
  sed -i 's/modules-center =.*$/modules-center = tagsbar_active/' ~/.dotfiles/polybar/.config/polybar/config.ini
fi

polybar-msg cmd restart

