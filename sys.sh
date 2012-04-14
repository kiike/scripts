#!/bin/sh
cat /proc/pmu/battery_0 | tr -d ' .' | tr ':' '=' > /tmp/battery_0
source /tmp/battery_0
T="/sys/devices/temperatures/"
fan="$(cat $T/sensor1_fan_speed | cut -f2-3 -d' ' | tr -d ' ()')"
cpu_temp="$(cat $T/sensor1_temperature)ºC"
gpu_temp="$(cat $T/sensor2_temperature)ºC"
bat="$((100 * $charge / $max_charge))%"

echo "f:$fan | t:$cpu_temp | ↯$bat"
