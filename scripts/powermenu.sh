#!/bin/bash

chosen=$(printf " Lock\n Logout\n Reboot\n Shutdown" | rofi -dmenu -i -p "Power")

case "$chosen" in
    " Lock") i3lock -c 000000 ;;
    " Logout") i3-msg exit ;;
    " Reboot") systemctl reboot ;;
    " Shutdown") systemctl poweroff ;;
esac

