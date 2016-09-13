#!/bin/bash

echoerr() { 
    echo "$@" 1>&2 
}

echoerr "Both handlers (graphite, influxdb) are activated, the consul-template currently supports only one."
exit 2
