#!/bin/bash

# Tonton Jo - 2023
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# Usage:
# put scrit where you want
# chmod +x /path/to/cpu_scale.sh
# Edit crontab to run script at every reboot ->
# @reboot  bash "/root/cpu_scale.sh" >/dev/null 2>&1"
# Reboot
# Test :)

# Version 1.0: Proof of concept
# Version 1.1: Loop is better than cron, will run everytime the script end

# --------------------- Settings ------------------------------------
averageloadupscaletime=3					# time to get average CPU load value in order to upscale
averageloaddownscaletime=10					# time to get average CPU load value in order to downscale

lowloadgouvernor=powersave		# CPU Scheduler to use when low usage
upscalevalue=50					# At wich usage when LOW load gouvernor is set the CPU will upscale to hi load

highloadgouvernor=schedutil		# CPU Scheduler to use when low usage
downscalevalue=15				# At wich usage when HIGH load gouvernor is set the CPU will downscale to low load
# --------------------- Settings ------------------------------------
# ------------------- Env Variables ----------------------------------
execdir=$(dirname $0)
# ------------------- Env Variables ----------------------------------
echo "- Starting Script" >> $execdir/cpu_scale.log
while true; do 
# --------------------- loop Variables ------------------------------------
actualgouvernor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
date=$(date +%Y_%m_%d-%H_%M_%S)
# --------------------- loop Variables ------------------------------------
# In order to not rank up or down too fast, define the average value to use
if echo "$actualgouvernor" | grep -Eqi "$lowloadgouvernor"; then
	cpuload=$(echo "$[100-$(vmstat 1 $averageloadupscaletime|tail -1|awk '{print $15}')]")
else	
	cpuload=$(echo "$[100-$(vmstat 1 $averageloaddownscaletime|tail -1|awk '{print $15}')]")
fi

# If the actual gouvernor is the low load gouvernor, check if CPU load is above upscale value
if echo "$actualgouvernor" | grep -Eqi "$lowloadgouvernor"; then
	if (( $(echo "$cpuload > $upscalevalue"))); then
		echo "- $date - Upscaling CPU power to $highloadgouvernor at $upscalevalue% CPU load" >> $execdir/cpu_scale.log
		echo "$highloadgouvernor" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	fi
# If the actual gouvernor is the high load gouvernor, check if value is under downscale value
elif echo "$actualgouvernor" | grep -Eqi "$highloadgouvernor"; then
	if (( $(echo "$cpuload < $downscalevalue"))) ; then
		echo "- $date - Downscaling CPU power to $lowloadgouvernor at $downscalevalue% CPU load" >> $execdir/cpu_scale.log
		echo "$lowloadgouvernor" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	fi
# If none of the above, define the low load CPU Gouvernor
else 
	echo "- $date - auto set low load gouvernor" >> $execdir/cpu_scale.log
	echo "$lowloadgouvernor" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi

echo "- CPU USAGE: $cpuload% - Gouvernor: $actualgouvernor"
done
