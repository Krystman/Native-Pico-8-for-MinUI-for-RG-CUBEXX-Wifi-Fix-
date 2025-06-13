#!/bin/bash

cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"
LOG="$SCRIPT_DIR/log.txt"
CONF_NAME="wifi.conf"
WPA_CONF="$SCRIPT_DIR/$CONF_NAME"
WIFI_IFACE="wlan0"
RES_PATH="$(dirname "$0")/res"

echo "[INFO] Running Wi-Fi toggle script..." | tee "$LOG"

# Check config file
if [ ! -f "$WPA_CONF" ]; then
    echo "[ERROR] Missing config: $WPA_CONF" | tee -a "$LOG"
	show.elf "$RES_PATH/config_error.png" 2
    exit 0
fi

# Extract SSID and password from config
SSID=$(grep '^ *ssid=' "$WPA_CONF" | head -n1 | cut -d'"' -f2)
PASSWORD=$(grep psk "$WPA_CONF" | head -n1 | sed 's/psk=//; s/"//g')

if [ -z "$SSID" ]; then
    echo "[ERROR] Could not parse SSID from config." | tee -a "$LOG"
    show.elf "$RES_PATH/config_error.png" 2
    exit 0
fi
if [ "$SSID" = "Your Wi-fi" ] || [ "$PASSWORD" = "Your password" ]; then
    echo "[ERROR] Please edit the wifi.conf file and provide a valid SSID and password." | tee -a "$LOG"
    show.elf "$RES_PATH/config_error.png" 2
    exit 0
fi

# Determine current SSID
echo "[INFO] Checking current Wi-Fi connection on $WIFI_IFACE..." | tee -a "$LOG"
CURRENT_SSID=$(iw "$WIFI_IFACE" link | grep 'SSID:' | awk -F'SSID: ' '{print $2}')
echo "[DEBUG] Current SSID: $CURRENT_SSID" | tee -a "$LOG"

if [ "$CURRENT_SSID" = "$SSID" ]; then
    echo "[INFO] Already connected to $SSID. Toggling OFF..." | tee -a "$LOG"
	show.elf "$RES_PATH/disable.png" 1

    echo "[INFO] Killing wpa_supplicant..." | tee -a "$LOG"
    pkill -f wpa_supplicant

    echo "[INFO] Releasing IP address..." | tee -a "$LOG"
    dhclient -r "$WIFI_IFACE" 2>>"$LOG"

    echo "[INFO] Bringing interface down..." | tee -a "$LOG"
    ip link set "$WIFI_IFACE" down

    echo "[SUCCESS] Wi-Fi disabled." | tee -a "$LOG"
	show.elf "$RES_PATH/disconnected.png" 1
    exit 0
fi

# Not connected — try to connect
echo "[INFO] Not connected to $SSID. Toggling ON and connecting..." | tee -a "$LOG"
show.elf "$RES_PATH/enable.png" 0

echo "[INFO] Bringing interface up..." | tee -a "$LOG"
ip link set "$WIFI_IFACE" up 2>>"$LOG"

echo "[INFO] Killing existing wpa_supplicant..." | tee -a "$LOG"
pkill -f wpa_supplicant
sleep 1

echo "[INFO] Creating control interface directory..." | tee -a "$LOG"
mkdir -p /tmp/wpa_supplicant

echo "[INFO] Starting wpa_supplicant..." | tee -a "$LOG"
wpa_supplicant -B -i "$WIFI_IFACE" -c "$WPA_CONF" -C /tmp/wpa_supplicant 2>>"$LOG"

echo "[INFO] Waiting for association..." | tee -a "$LOG"

DELAY=15
associated=0
frame=1

for i in `seq 1 $DELAY`; do
    STATUS=$(iw "$WIFI_IFACE" link)
    echo "[DEBUG] iw status: $STATUS" | tee -a "$LOG"
    if echo "$STATUS" | grep -q "SSID: $SSID"; then
		associated=1
        echo "[INFO] Successfully associated with $SSID." | tee -a "$LOG"
        break
    fi
    show.elf "$RES_PATH/connecting_${frame}.png" 1
    frame=$((frame + 1))
    if [ $frame -gt 3 ]; then
        frame=1
    fi
done
killall -s KILL show.elf

if [ $associated -eq 0 ]; then
	echo "[FAILURE] Failed to associate with Wi-Fi." | tee -a "$LOG"
	show.elf "$RES_PATH/connect_fail.png" 1
	exit 0
fi
	
echo "[INFO] Requesting IP via DHCP..." | tee -a "$LOG"
dhclient "$WIFI_IFACE" 2>>"$LOG"

IP=$(ip addr show "$WIFI_IFACE" | grep 'inet ' | awk '{print $2}')
if [ -n "$IP" ]; then
    echo "[SUCCESS] Connected to $SSID with IP: $IP" | tee -a "$LOG"
	show.elf "$RES_PATH/connected.png" 1
else
    echo "[FAILURE] Failed to connect to $SSID." | tee -a "$LOG"
	show.elf "$RES_PATH/connect_fail.png" 1
fi