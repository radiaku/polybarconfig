#!/bin/bash
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null)
if [ -z "$temp" ]; then
    echo "N/A"
else
    echo "${temp}°C"
fi
