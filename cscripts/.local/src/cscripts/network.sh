#!/bin/bash

ETH_INTERFACE="enp0s20f0u"
WIFI_INTERFACE="wlo1"

ETH_STATUS=$(nmcli -t -f DEVICE,STATE dev | grep "^$ETH_INTERFACE" | cut -d: -f2)
if [ "$ETH_STATUS" = "connected" ]; then
    echo "%{T2}󰈀%{T-}  Ethernet"
    exit 0
fi

WIFI_STATUS=$(nmcli -t -f DEVICE,STATE dev | grep "^$WIFI_INTERFACE:" | cut -d: -f2)
if [ "$WIFI_STATUS" = "connected" ]; then
    WIFI_INFO=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep "^yes:" | head -1)
    if [ -n "$WIFI_INFO" ]; then
        SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
        SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)

        if [ "$SIGNAL" -gt 95 ]; then
            ICON="󰤨"
        elif [ "$SIGNAL" -gt 60 ]; then
            ICON="󰤥"
        elif [ "$SIGNAL" -gt 45 ]; then
            ICON="󰤢"
        elif [ "$SIGNAL" -gt 30 ]; then
            ICON="󰤟"
        else
            ICON="󰤯"
        fi

        echo "%{T2}$ICON%{T-}  $SSID"
    else
        echo "%{F#636578}%{T2}󰤮%{T-}  Disconnected%{F-}"
    fi
else
    echo "%{F#636578}%{T2}󰤮%{T-}  Disconnected%{F-}"
fi
