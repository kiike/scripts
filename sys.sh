#!/bin/sh
# System info for Tmux

TEMP_PATH="/sys/class/thermal/thermal_zone0"
BATT_PATH="/sys/class/power_supply/BAT0/"

# Print CPU temperature
if [ -d ${TEMP_PATH} ]; then
	temp="$(< ${TEMP_PATH}/temp)"
	cpu_temp=${temp::-3}
	echo -n "CPU: ${cpu_temp}degC | "
fi


# Print battery charge
if [ -d ${BATT_PATH} ]; then
	max_charge="$(< ${BATT_PATH}/energy_full)"
	cur_charge="$(< ${BATT_PATH}/energy_now)"
	bat="$((100 * $cur_charge / $max_charge))"
	echo -n "↯${bat}% | "
fi

# Print date
date '+%a %d %b, %H:%M'
