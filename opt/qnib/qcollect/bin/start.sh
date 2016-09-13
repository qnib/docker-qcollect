#!/usr/local/bin/dumb-init /bin/bash


source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http

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
QCOLLECT_HOSTNAME=${QCOLLECT_HOSTNAME-${HOSTNAME}}
consul-template -consul localhost:8500 -once -template /etc/consul-templates/qcollect/qcollect.conf.ctmpl:/etc/qcollect/qcollect.conf
/usr/bin/qcollect -c /etc/qcollect/qcollect.conf
