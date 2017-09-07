#!/usr/bin/env bash

dir=$HOME/documents/handyscripts

stuff="
    $HOME/bin/add_number.py
    $HOME/bin/add-pdf-page-numbers.sh
    $HOME/bin/aenea.sh
    $HOME/bin/cb
    $HOME/bin/drm_rm.sh
    $HOME/bin/eco
    $HOME/bin/emacsdiff
    $HOME/bin/pdf-concat
    $HOME/bin/renamepdf
    $HOME/bin/rmspace
    $HOME/bin/zoterobib2db.sh
    $HOME/bin/.backup_file.sh
    $HOME/bin/.setup_linux.sh
    $HOME/bin/.switch-wifi.sh
    $HOME/bin/.sync_phone.sh
    $HOME/bin/sync_org.sh
    $HOME/bin/.update_playlists.sh
    $HOME/bin/.work-screen.sh
    $HOME/bin/.copy-scripts.sh
"


if [[ $1 == "out" ]];then
    cp -a $stuff $dir/
    echo commit like this:
    echo "  cd $dir;  git commit . -m 'saving things' && git push origin master; cd -"
fi

if [[ $1 == "in" ]];then
    cd $dir;  git pull
    for s in $stuff; do
        cp -a $(basename $s) $(dirname $s)
    done
    cd -
fi
