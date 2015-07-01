#!/bin/bash
#
# Prerequisites:
#   install zenpacks:
#     for svc in mariadb-model mariadb-events zope /redis rabbitmq memcached zeneventserver zencatalogservice; do serviced service start $svc; done
#     watch serviced service status   # wait for those services to start
#     cd /tmp
#     serviced service run zope zenpack install dist/ZenPacks.zenoss.CalculatedPerformance-2.1.0dev-py2.7.egg
#     serviced service run zope zenpack install dist/ZenPacks.test.CalcPerfScale-1.0.0dev-py2.7.egg
#     serviced service stop mgr
#     serviced service snapshot mgr
#
#     serviced service start mgr
#     watch serviced service status   # wait for those services to start and zenhub to have good healthchecks
#

function disable_services
{
    DISABLE_SERVICE_SH="/tmp/disable-service.sh"

    cat <<'EOF' >$DISABLE_SERVICE_SH
#!/bin/bash
sed -i -e 's/   "Launch": "auto",/   "Launch": "manual",/' "$1"
EOF
    chmod +x $DISABLE_SERVICE_SH

    for svc in zenjmx zenmailtx zenperfsnmp zenprocess zenpropertymonitor zensyslog zentrap zenucsevents zenvsphere zenwebtx; do
        echo "disabling and stopping service: $svc"
        EDITOR=$DISABLE_SERVICE_SH serviced service edit localhost/$svc; serviced service stop localhost/$svc;
    done
serviced service stop localhost/zencommand
serviced service stop localhost/zenpython
}

function generate_collectors
{
    echo "creating collectors..."
    serviced service attach localhost/zenhub/0 su - zenoss -c 'for i in {11..25}; do dc-admin add-collector col$i; done'
}

function generate_zenbatchload
{
ZB="/tmp/zenbatchload.txt"
echo /Test/CalcPerf >$ZB
for i in {11..25}; do
        IP="10.171.100.$i"  # these hosts are pingable simulated IPs from QA
        echo "cphost$i setManageIp='$IP', setPerformanceMonitor='col$i', zCollectorClientTimeout=1200, zTestCalcPerfTopComponentsPerDevice=3000, zTestCalcPerfBottomComponentsPerTopComponent=2" >>$ZB

        echo generated zenbatchload entry for cphost$i $IP
done
echo "created zenbatchload file: $ZB"
cat $ZB
echo "run this manually: serviced service shell -i --mount /tmp,/mnt/tmp zenhub su - zenoss -c 'zenbatchload /mnt/$ZB'"
}

disable_services
generate_collectors
generate_zenbatchload

