#!/bin/sh

player_status=$(playerctl -p spotify status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo "[>] $(playerctl -p spotify metadata --format '{{ artist }} - {{ title }}')"
elif [ "$player_status" = "Paused" ]; then
    echo "[-] $(playerctl -p spotify metadata --format '{{ artist }} - {{ title }}')"
else
    echo "No music is playing"
fi
