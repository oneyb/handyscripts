#!/bin/bash -x
sudo ip link set wlan1 down
sudo ip link set wlan0 down
sleep 1
sudo ip link set wlan0 up
sudo ip link set wlan1 up
sudo systemctl restart network* wicd.service avahi-daemon*
