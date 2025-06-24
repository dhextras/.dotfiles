#!/bin/bash

rofi -show drun \
     -theme ~/.config/rofi/config.rasi \
     -font "ComicShannsMono Nerd Font 12" \
     -icon-theme "Papirus-Dark" \
     -show-icons \
     -terminal st \
     -ssh-client ssh \
     -ssh-command "{terminal} -e {ssh-client} {host} [-p {port}]" \
     -run-shell-command "{terminal} -e {cmd}" \
     -run-command "/bin/bash -c '{cmd} && read'" \
     -display-drun "Apps" \
     -display-run "Run" \
     -display-window "Windows" \
     -display-ssh "SSH" \
     -drun-display-format "{name} [<span weight='light' size='small'><i>({generic})</i></span>]" \
     -window-format "{w}    {c}   {t}" \
     -matching fuzzy \
     -sort \
     -threads 0 \
     -scroll-method 0 \
     -drun-use-desktop-cache \
     -drun-reload-desktop-cache \
     -normalize-match \
     -steal-focus \
     -parse-hosts \
     -parse-known-hosts \
     -combi-modi "window,drun,ssh" \
     -modi "combi,window,drun,run,ssh"
