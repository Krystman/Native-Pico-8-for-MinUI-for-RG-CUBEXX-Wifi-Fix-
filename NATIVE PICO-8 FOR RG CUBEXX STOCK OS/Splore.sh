#!/bin/sh

APPS_DIR="$(dirname "$0")"
DIR="$APPS_DIR/Splore.pak"
PICO8_DIR="$DIR/pico-8"

export LD_LIBRARY_PATH="$DIR:$LD_LIBRARY_PATH"
export PATH="$DIR:$PATH"

. "$DIR/test_btns"

monitor_for_kill() {
while true; do
	Test_Button_POWER
	[ $? -eq 10 ] && killall -15 pico8_dyn
	sleep 0.05
done
}

# enable volume and brightness controls
echo "1" > "/sys/class/power_supply/axp2202-battery/nds_esckey"
echo "0" > "/sys/class/power_supply/axp2202-battery/nds_pwrkey"
{
	/mnt/vendor/bin/ndsCtrl.dge
	monitor_for_kill
} &

# run the actual thingy
cd "$PICO8_DIR" && ./pico8_dyn -splore -joystick 0 -root_path "$APPS_DIR/../PICO" > ./splore-log.txt 2>&1

# give volume and brightness controls back to dmenu.bin
kill $!
echo "0" > "/sys/class/power_supply/axp2202-battery/nds_esckey"
echo "0" > "/sys/class/power_supply/axp2202-battery/nds_pwrkey"