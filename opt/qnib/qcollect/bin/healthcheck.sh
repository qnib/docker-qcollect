#!/bin/bash


echo -n "Check if port ${QCOLLECT_INTERNAL_SERVER_PORT} is open (nmap localhost -p ${QCOLLECT_INTERNAL_SERVER_PORT}..."
nmap localhost -p ${QCOLLECT_INTERNAL_SERVER_PORT} |grep open >/dev/null
if [ $? -ne 0 ];then
   echo "Check if port ${QCOLLECT_INTERNAL_SERVER_PORT} is open (nmap localhost -p ${QCOLLECT_INTERNAL_SERVER_PORT})... [ERR]"
   exit 2
else
   echo "[OK]"
   exit 0
fi
