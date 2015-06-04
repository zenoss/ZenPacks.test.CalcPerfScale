#!/bin/bash

ZB="/tmp/zenbatchload.txt"
echo /Test/CalcPerf >$ZB
for i in {1..15}; do
        IP="10.171.100.$i"  # these hosts are pingable simulated IPs from QA
        echo "cphost$i setManageIp='$IP', setPerformanceMonitor='col$i', zTestCalcPerfTopComponentsPerDevice=5, zTestCalcPerfBottomComponentsPerTopComponent=2" >>$ZB

        echo started host$i $IP

        i=$(($i+1));
done
echo created $ZB
cat $ZB

