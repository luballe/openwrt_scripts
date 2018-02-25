#!/bin/bash
logPath=/home/pi/openwrt_scripts/log.txt
for run in {1..525600}
do
  # Run in background. Each run has to last less than a second.
  /home/pi/openwrt_scripts/showStatus.sh >> $logPath &
  sleep 60
done
