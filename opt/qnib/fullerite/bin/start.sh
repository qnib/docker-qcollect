#!/usr/local/bin/dumb-init /bin/bash

source /opt/qnib/consul/etc/bash_functions.sh

wait_for_srv carbon
FULLERITE_HOSTNAME=${FULLERITE_HOSTNAME-${HOSTNAME}}
consul-template -consul localhost:8500 -once -template /etc/consul-templates/fullerite/fullerite.conf.ctmpl:/etc/fullerite/fullerite.conf
fullerite -c /etc/fullerite/fullerite.conf

