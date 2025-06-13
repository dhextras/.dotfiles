picom --config ~/.config/picom/picom.conf &
feh --bg-scale "/home/dhextras/Desktop wallpaper/grung-green-yellow-refd.png" &
eval $(dbus-launch --sh-syntax)
devmon --no-gui --exec-on-drive "~/.local/src/cscripts/mountnotify.sh mount \$UDI" --exec-on-unmount "~/.local/src/cscripts/mountnotify.sh umount \$UDI" &
exec dwm
