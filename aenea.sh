#!/bin/bash

if [ $# -ne 1 ]; then
    echo Please give the name of the VM to be used
    exit
fi

setxkbmap us
aenea_HOME=/stuff/aenea
aenea_HOME=~/aenea

if [ $1 == "windows7" ]; then
    VirtualBox --startvm windows7 2>&1 ~/.vm.log
    sleep 12
    cd $aenea_HOME/aenea3/server/linux_x11/
    if [ -z "`pgrep -f server_x11.py`" ]; then
	      python server_x11.py > $aenea_HOME/.aenea.log 2> $aenea_HOME/.aenea.log &
    else
	      pkill -f server_x11.py
	      python server_x11.py > $aenea_HOME/.aenea.log 2> $aenea_HOME/.aenea.log &
    fi
fi

if [ $1 == "x" ]; then
    VirtualBox --startvm x 2>&1 $aenea_HOME/.vm.log
    cd $aenea_HOME/aenea/
    if [ -z "`pgrep -f server_x11.py`" ]; then
	      python server_x11.py > $aenea_HOME/.aenea.log 2> $aenea_HOME/.aenea.log &
    else
	      pkill -f server_x11.py
	      python server_x11.py > $aenea_HOME/.aenea.log 2> $aenea_HOME/.aenea.log &
    fi
fi
