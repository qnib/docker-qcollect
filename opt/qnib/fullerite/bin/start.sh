#!/usr/local/bin/dumb-init /bin/bash


source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http

if [ ${FULLERITE_GRAPHITE_ENABLED} == "true" ] && [ ${FULLERITE_INFLUXDB_ENABLED} == "true" ];then
    logger -s "Both handlers (graphite, influxdb) are activated, the consul-template currently supports only one."
    sleep 5
    cp /opt/qnib/fullerite/etc/warn_fullerite.json /etc/consul.d/
    consul reload
    exit 0
fi
wait_for_srv influxdb
FULLERITE_HOSTNAME=${FULLERITE_HOSTNAME-${HOSTNAME}}
consul-template -consul localhost:8500 -once -template /etc/consul-templates/fullerite/fullerite.conf.ctmpl:/etc/fullerite/fullerite.conf
/opt/fullerite/bin/fullerite -c /etc/fullerite/fullerite.conf
