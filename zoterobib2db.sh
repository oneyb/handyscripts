#!/bin/bash

#  Keep literature organized
#
#  Copyright (C) 2016  Brian J. Oney, brian.j.oney|at|gmail.com
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ $# -eq 0 ]; then
    echo Usage: zoterobib2db.sh PATH-TO-BIBLIOGRAPHY-FILE.BIB DESTINATION-DIRECTORY/
    echo "Use standard values? (y/n)"
    read answer
    if [ $answer == "y" ]; then
        dbdir=~/action/bugs/literature
        file=~/zotero/Insects.bib
    else
        exit 1
    fi
else
    file=$1
    if [ ! -f $file ]; then
        echo $file not found
        exit 1
    fi
    dbdir=$2
fi

cd `dirname $file`

# sync
rsync -vurt --delete `sed -r '/file = /!d;s/^.*:\/(.*):a.*$/\1/' $file` $dbdir/
