#!/usr/bin/env bash

# simple status:
# - off  : service mati
# - on   : service hidup tapi nggak ada device connected
# - conn : ada device connected

if ! systemctl is-active --quiet bluetooth; then
  echo " off"
  exit 0
fi

if bluetoothctl info | grep -q "Connected: yes"; then
  echo " conn"
elif bluetoothctl devices Connected | grep -q "Device"; then
  echo " conn"
else
  echo " avail"
fi
