#!/bin/bash

FLAG="$HOME/.cache/polybar_show_all_tags"
[[ ! -f "$FLAG" ]] && echo "0" > "$FLAG"

current=$(cat "$FLAG")

if [[ "$current" == "1" ]]; then
  echo "0" > "$FLAG"
else
  echo "1" > "$FLAG"
fi

~/.local/src/cscripts/tagsmode.sh
