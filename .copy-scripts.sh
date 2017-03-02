#!/usr/bin/env bash
dir=$HOME/documents/handyscripts

stuff="
    $HOME/bin/add-pdf-page-numbers.sh
    $HOME/bin/aenea.sh
    $HOME/bin/cb
    $HOME/bin/drm_rm.sh
    $HOME/bin/eco
    $HOME/bin/pdf-concat
    $HOME/bin/renamepdf
    $HOME/bin/rmspace
    $HOME/bin/zoterobib2db.sh
    $HOME/bin/.backup_file.sh
    $HOME/bin/.configure_linux.sh
    $HOME/bin/.convert_scans.sh
    $HOME/bin/.switch-wifi.sh
    $HOME/bin/.sync_phone.sh
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
    for s in $stuff; do
        cp $dir/`basename $s` `dirname $s`
    done
fi
