#!/bin/bash

if bluetoothctl show | grep -q "Powered: yes"; then
    # Check if any device is connected
    if bluetoothctl info | grep -q "Connected: yes"; then
        # Get connected device name
        device=$(bluetoothctl info | grep "Name:" | cut -d' ' -f2-)
        echo "%{T2}󰂯%{T-} $device"
    else
        echo "%{T2}󰂯%{T-} On"
    fi
else
    echo "%{T2}󰂲%{T-} Off"
fi
