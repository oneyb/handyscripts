#!/usr/bin/env bash
dir=$HOME/documents/handyscripts

stuff="
    $HOME/bin/add_number.py
    $HOME/bin/add-pdf-page-numbers.sh
    $HOME/bin/aenea.sh
    $HOME/bin/cb
    $HOME/bin/dbi
    $HOME/bin/drm_rm.sh
    $HOME/bin/eco
    $HOME/bin/pdf-concat
    $HOME/bin/renamepdf
    $HOME/bin/rmspace
    $HOME/bin/zoterobib2db.sh
    $HOME/bin/.backup_file.sh
    $HOME/bin/send-to-printer.py
    $HOME/bin/.switch-wifi.sh
    $HOME/bin/.sync_phone.sh
    $HOME/bin/sync_org.sh
    $HOME/bin/.update_playlists.sh
    $HOME/bin/.work-screen.sh
    $HOME/bin/.copy-scripts.sh
"


if [[ $1 == "out" ]];then
    cp $stuff $dir/
    echo commit like this:
    echo "  cd $dir;  git commit . -m 'saving things' && git push origin master; cd -"
fi

if [[ $1 == "in" ]];then
	cd $dir
	git pull
    for s in $stuff; do
        cp `basename $s`  $s
    done
    cd -
fi
