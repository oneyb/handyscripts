#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    dir=~/documents/scans
else
    dir=$1
fi

cd $dir
rename 's/ /-/g' *

find . -mindepth 1 -type d | while read d; do
    convert -density 300 $d/* $d.pdf
    # pdftk $d/*pdf cat output $d.pdf
done
