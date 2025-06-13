#!/bin/bash

action="$1"   # "mount" or "umount"
dev="$2"

label=$(lsblk -no LABEL "$dev" | head -n 1)
mountpoint=$(udevil info "$dev" 2>/dev/null | grep '^Mount point' | cut -d':' -f2- | xargs)

# fallback if no label
if [[ -z "$label" ]]; then
    label="$dev"
fi

if [[ "$action" == "mount" ]]; then
    notify-send "📦 Mounted: $label" "At $mountpoint"
elif [[ "$action" == "umount" ]]; then
    notify-send "📤 Unmounted: $label"
fi

