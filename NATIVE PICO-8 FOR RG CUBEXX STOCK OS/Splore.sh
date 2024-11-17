#!/bin/sh

APPS_DIR="$(dirname "$0")"
DIR="$APPS_DIR/Splore.pak"
PICO8_DIR="$DIR/pico-8"

export LD_LIBRARY_PATH="$DIR:$LD_LIBRARY_PATH"
export PATH="$DIR:$PATH"

# enable volume and brightness controls
echo "1" > "/sys/class/power_supply/axp2202-battery/nds_esckey"
echo "0" > "/sys/class/power_supply/axp2202-battery/nds_pwrkey"
{
	/mnt/vendor/bin/ndsCtrl.dge
} &

# run the actual thingy
cd "$PICO8_DIR" && ./pico8_dyn -splore -joystick 0 -root_path "$APPS_DIR/../PICO" > ./splore-log.txt 2>&1

# give volume and brightness controls back to dmenu.bin
kill $!
echo "0" > "/sys/class/power_supply/axp2202-battery/nds_esckey"
echo "0" > "/sys/class/power_supply/axp2202-battery/nds_pwrkey"