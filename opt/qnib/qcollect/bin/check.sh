#!/bin/bash

echoerr() { 
    echo "$@" 1>&2 
}

echo -n 'Check if port 19191 is open (nmap localhost -p 19191)... '
nmap localhost -p 19191 |grep open >/dev/null
if [ $? -ne 0 ];then
   echoerr "Check if port 19191 is open (nmap localhost -p 19191)... [ERR]"
   exit 2
else
   echo "[OK}"
   exit 0
fi
