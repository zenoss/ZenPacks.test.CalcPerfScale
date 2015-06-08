#!/bin/bash

ZB="/tmp/zenbatchload.txt"
echo /Test/CalcPerf >$ZB
for i in {11..25}; do
        IP="10.171.100.$i"  # these hosts are pingable simulated IPs from QA
        echo "cphost$i setManageIp='$IP', setPerformanceMonitor='col$i', zTestCalcPerfTopComponentsPerDevice=100, zTestCalcPerfBottomComponentsPerTopComponent=2" >>$ZB

        echo started host$i $IP
done
echo created $ZB
cat $ZB

