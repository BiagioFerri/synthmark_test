#!/bin/bash
i=0
max=7
while [ $i -lt $max ]
do
    echo performance > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
    echo 1 > /sys/devices/system/cpu/cpu$i/cpuidle/state3/disable
    echo 0 > /sys/devices/system/cpu/cpu$i/cpuidle/state2/disable
    echo 0 > /sys/devices/system/cpu/cpu$i/cpuidle/state1/disable
    true $(( i++ ))
done
