#!/bin/bash
temp=$(cat /sys/class/hwmon/hwmon6/temp1_input)
printf "%d°C" $((temp / 1000))

