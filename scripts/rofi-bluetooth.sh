#!/usr/bin/env bash

# ============================================
#  Rofi Bluetooth Manager
# ============================================

# Helper to get controller info
POWER=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
SCAN=$(bluetoothctl show | grep "Discovering:" | awk '{print $2}')
MENU=""

# Build the menu header
MENU+="Bluetooth Manager\n"
MENU+="────────────────────\n"

# Power toggle
if [[ $POWER == "yes" ]]; then
    MENU+="Power: ON\n"
else
    MENU+="Power: OFF\n"
fi

# Scan toggle
if [[ $SCAN == "yes" ]]; then
    MENU+="Scan: ON\n"
else
    MENU+="Scan: OFF\n"
fi

MENU+="────────────────────\n"

# Paired + connected devices
PAIRED=$(bluetoothctl paired-devices | awk '{print $2}')

for MAC in $PAIRED; do
    NAME=$(bluetoothctl info "$MAC" | grep "Name:" | cut -d' ' -f2-)
    CONNECTED=$(bluetoothctl info "$MAC" | grep "Connected:" | awk '{print $2}')

    if [[ $CONNECTED == "yes" ]]; then
        MENU+="$NAME [$MAC] (connected)\n"
    else
        MENU+="$NAME [$MAC]\n"
    fi
done

MENU+="────────────────────\n"
MENU+="Scan for new device\n"
MENU+="Quit"

CHOICE=$(echo -e "$MENU" | rofi -dmenu -i -p "Bluetooth")

# ==========================
#  Handle Menu Actions
# ==========================

case "$CHOICE" in
    "Power: OFF") bluetoothctl power on ;;
    "Power: ON") bluetoothctl power off ;;
    "Scan: OFF") bluetoothctl scan on ;;
    "Scan: ON") bluetoothctl scan off ;;
    "Scan for new device")
        rofi -e "Run 'bluetoothctl scan on' then monitor new devices."
        ;;
    "Quit") exit 0 ;;
    *)
        # Detect device selection
        if echo "$CHOICE" | grep -q "\["; then
            MAC=$(echo "$CHOICE" | grep -oP '\[\K([^\]]+)')
            NAME=$(echo "$CHOICE" | cut -d '[' -f1)

            SUBMENU=$(printf "Connect\nDisconnect\nTrust\nUntrust\nRemove\nInfo\nBack" | rofi -dmenu -i -p "$NAME")

            case "$SUBMENU" in
                "Connect") bluetoothctl connect "$MAC" ;;
                "Disconnect") bluetoothctl disconnect "$MAC" ;;
                "Trust") bluetoothctl trust "$MAC" ;;
                "Untrust") bluetoothctl untrust "$MAC" ;;
                "Remove") bluetoothctl remove "$MAC" ;;
                "Info") bluetoothctl info "$MAC" | rofi -e ;;
                *) exit 0 ;;
            esac
        fi
        ;;
esac

