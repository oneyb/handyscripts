#!/usr/bin/env bash

mode="$(xrandr -q|grep -A1 "VGA1 connected"| tail -1 |awk '{ print $1 }')"

if [ -n "$mode" ]; then
    xrandr --newmode "1600x1000_60.00"  132.25  1600 1696 1864 2128  1000 1003 1009 1038 -hsync +vsync
    xrandr --addmode VGA1 1600x1000_60.00
    xrandr --output VGA1 --mode 1600x1000_60.00
    xrandr --output LVDS1 --off
else
    xhost +
    xrandr --auto
    xhost -
fi
