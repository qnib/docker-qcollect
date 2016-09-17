#!/usr/local/bin/dumb-init /bin/bash


source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http

if [ -f /etc/docker-hostname ];then
    if [ $(tail -n1 /etc/docker-hostname |grep -c =) -eq 1 ];then
	source /etc/docker-hostname
        export QCOLLECT_HOSTNAME=${hostname}
    else
        export QCOLLECT_HOSTNAME=$(cat /etc/docker-hostname)
    fi
else
    export QCOLLECT_HOSTNAME=${QCOLLECT_HOSTNAME-${HOSTNAME}}
fi

if [ ${QCOLLECT_GRAPHITE_ENABLED} == "true" ] && [ ${QCOLLECT_INFLUXDB_ENABLED} == "true" ];then
    logger -s "Both handlers (graphite, influxdb) are activated, the consul-template currently supports only one."
    sleep 5
    cp /opt/qnib/qcollect/etc/warn_qcollect.json /etc/consul.d/
    consul reload
    exit 0
fi
if [ "${QCOLLECT_INFLUXDB_ENABLED}" == "true" ] && [ "X${QCOLLECT_SKIP_INFLUX_CHECK}" != "Xtrue" ];then
    wait_for_srv influxdb
fi
consul-template -consul localhost:8500 -once -template /etc/consul-templates/qcollect/qcollect.conf.ctmpl:/etc/qcollect/qcollect.conf
consul-template -once -template /etc/consul-templates/qcollect/DockerStats.conf.ctmpl:/etc/qcollect/conf.d/DockerStats.conf
consul-template -once -template /etc/consul-templates/qcollect/OpenTSDB.conf.ctmpl:/etc/qcollect/conf.d/OpenTSDB.conf
/usr/bin/qcollect -c /etc/qcollect/qcollect.conf
