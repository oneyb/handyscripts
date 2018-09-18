#!/bin/bash

if [ $# -ne 1 ]; then
    echo Please give the name of the VM to be used
    exit
fi

# setxkbmap us
aenea_HOME=~/aenea

if [ $1 == "w7" ]; then
    if [ -z "`pgrep -f VirtualBox`" ]; then
        bash -c "VirtualBox --startvm $1 2>&1 ~/.vm.log" &
    fi
    sleep 12
    cd $aenea_HOME/aenea/server/linux_x11/
    if [ -z "`pgrep -f server_x11.py`" ]; then
	      bash -c "python server_x11.py &> $aenea_HOME/.aenea.log" &
    else
	      pkill -f server_x11.py
	      bash -c "python server_x11.py &> $aenea_HOME/.aenea.log" &
    fi
fi

if [ $1 == "x" ]; then
    if [ -z "`pgrep -f VirtualBox`" ]; then
        bash -c "VirtualBox --startvm $1 2>&1 ~/.vm.log" &
    fi
    cd $aenea_HOME/aenea-old/
    if [ -z "`pgrep -f server_x11.py`" ]; then
	      python server_x11.py > $aenea_HOME/.aenea.log 2> $aenea_HOME/.aenea.log &
    else
	      pkill -f server_x11.py
	      python server_x11.py > $aenea_HOME/.aenea.log 2> $aenea_HOME/.aenea.log &
    fi
fi
