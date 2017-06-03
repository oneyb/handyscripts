#!/bin/bash

if [[ -n "`pgrep -f 'emacs --daemon'`" ]]; then
    emacsclient -e '(save-some-buffers t)'
fi

if [ -z $(pgrep -f "dropbox-dist") ]; then
    cp -a $HOME/org/ $HOME/.org-bu_$(date +%F)/
    dropbox start
fi

sleep 12
killall -w dropbox
# $HOME/bin/.sync_org-agenda.sh
