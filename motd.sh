#!/bin/bash
echo "DATE	: `date`"
echo "UPTIME	: `uptime -p`"
echo "VERSION	: `cat /linux.prop | cut -c 24-31`"
echo ""
echo "<CPU INFO>"
echo "CLOCK	: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | cut -c1-4`MHz		GOV	: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`"
echo "TEMP	:`cat /proc/msp/pm_cpu | grep Tsensor | cut -f 2 -d "="`		USE	: `top -d 0.5 -b -n2 | grep "Cpu(s)"|tail -n 1 | awk '{print $2 + $4}'`%"

echo ""
echo "<MEMORY INFO>"
M_TOTAL=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
M_FREE=$(cat /proc/meminfo | grep MemAvailable | awk '{print $2}')
S_TOTAL=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
S_FREE=$(cat /proc/meminfo | grep SwapFree | awk '{print $2}')
echo "MEM	: `expr $M_TOTAL / 1024 - $M_FREE / 1024`MB / `expr $M_TOTAL / 1024`MB	SWAP	: `expr $S_TOTAL / 1024 - $S_FREE / 1024`MB / `expr $S_TOTAL / 1024`MB"
echo ""
echo "<NETWORK>"
echo "ETH	: `ip addr show | grep eth0 | grep inet | grep brd | awk '{print $2}' | awk -F/ '{print $1}'`		WIFI	: `ip addr show | grep wlan0 | grep inet | grep brd | awk '{print $2}' | awk -F/ '{print $1}'`"
echo ""
