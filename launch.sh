#!/usr/bin/env sh

# Kill running Polybar
killall -q polybar

# Wait for shutdown
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Force Polybar to use X11 inside Wayland
export GDK_BACKEND=x11
export QT_QPA_PLATFORM=xcb
export SDL_VIDEODRIVER=x11
export CLUTTER_BACKEND=x11

# Critical: remove Wayland DISPLAY variable
unset WAYLAND_DISPLAY

# Optional: prevent Hyprland from intercepting clicks
export HYPRLAND_NO_FRACTIONAL_SCALE=1

# Launch bar on each monitor
if type "xrandr" >/dev/null 2>&1; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  polybar --reload example &
fi
