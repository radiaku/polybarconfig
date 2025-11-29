#!/usr/bin/env bash

brightnessctl -m | cut -d, -f4

# Watch for brightness changes
brightnessctl -m -w | while read -r line; do
  echo "$line" | cut -d, -f4
done

