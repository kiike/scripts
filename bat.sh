#/bin/bash
# Outputs the battery level of an {i,Power}Book G4.

cat /proc/pmu/battery_0 | tr -d ' .' | tr ':' '=' > /tmp/battery_0
source /tmp/battery_0
echo $((100 * $charge / $max_charge))"%"
