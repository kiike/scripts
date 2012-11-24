#!/bin/sh

arch=$(uname -m)

if [ "$arch" == "ppc" ] || [ "$arch" == "ppc64" ]; then
	cat /proc/pmu/battery_0 | tr -d ' .' | tr ':' '=' > /tmp/battery_0
	source /tmp/battery_0
	T="/sys/devices/temperatures/"
	fan="$(cat $T/sensor1_fan_speed | cut -f2-3 -d' ' | tr -d ' ()')"
	cpu_temp="$(cat $T/sensor1_temperature)ºC"
	gpu_temp="$(cat $T/sensor2_temperature)ºC"
	bat="$((100 * $charge / $max_charge))%"
	
elif [ "$arch" == "x86" ] || [ "$arch" == "x86_64" ]; then
	max_charge=$(cat /sys/class/power_supply/BAT0/energy_full)
	cur_charge=$(cat /sys/class/power_supply/BAT0/energy_now)
	bat="$((100 * $cur_charge / $max_charge))%"
	T="/sys/class/thermal/"
	fan="$(cat $T/sensor1_fan_speed | cut -f2-3 -d' ' | tr -d ' ()')"
	cpu_temp_full=$(cat $T/thermal_zone0/temp)
	cpu_temp=${cpu_temp_full%000}
fi
	
echo "f:$fan | t:$cpu_temp | ↯$bat"
