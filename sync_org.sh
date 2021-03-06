#!/bin/bash -x

if [[ -n "`pgrep -f 'emacs --daemon'`" ]]; then
    emacsclient -e '(save-some-buffers t)'
fi

# if [ -z $(pgrep -f "dropbox-dist") ]; then
#     rm .org-bu
#     cp -a $HOME/org/ $HOME/.org-bu_$(date +%F)/
#     ln -s $HOME/.org-bu_$(date +%F) $HOME/.org-bu
#     dropbox start
#     sleep 3
# fi

# # while [[ "Up to date" != "$(dropbox status)" ]]; do sleep 3; done
# sleep 16

# conflicts=$(ls $HOME/org/*conflicted*)
# if [[ -n "$conflicts" ]]; then
#     xmessage -timeout 1  "Files are conflicted"
#     # emacsclient -c -e '(ediff-directories "~/org" "~/.org-bu" ".org$")'
#     for con in "$conflicts"; do
#         # echo "$con"
#         filenamebase=$(basename "$con" | sed -r 's/^([A-Za-z]+) .*$/\1.org/')
#         # emacsclient -c -e "(ediff-files '(file-expand-wildcards \"~/org/$filenamebase*.org\"))"
#         emacsclient -c -e "(ediff-files \"~/org/$filenamebase\" \"$con\"))" -e "(toggle-frame-maximized)"
#         # rm "~/org/$filenamebase *"
#     done
# fi

conflicts=$(ls $HOME/org/*conflicted*)
if [[ -n "$conflicts" ]]; then
    xmessage -timeout 1  "Files are conflicted"
    # emacsclient -c -e '(ediff-directories "~/org" "~/.org-bu" ".org$")'
    for con in "$conflicts"; do
        # echo "$con"
        filenamebase=$(basename "$con" | sed -r 's/^([A-Za-z]+) .*$/\1.org/')
        # emacsclient -c -e "(ediff-files '(file-expand-wildcards \"~/org/$filenamebase*.org\"))"
        emacsclient -c -e "(ediff-files \"~/org/$filenamebase\" \"$con\"))" -e "(toggle-frame-maximized)"
        # rm "~/org/$filenamebase *"
    done
fi

# $HOME/bin/.sync_org-agenda.sh
if [[ -z "`pgrep -f 'emacs'`" ]]; then
    emacs --daemon
    emacsclient -c --eval '(org-tags-view t "computer+TODO=\"NEXT\"")' --eval '(delete-other-windows)'
    # emacsclient -c --eval '(org-tags-view t "computer")' --eval '(delete-other-windows)'
    # emacsclient -c --eval '(org-tags-view t "computer")' --eval '(delete-other-windows)'
    # emacsclient -c --eval '(org-agenda-list)' --eval '(delete-other-windows)'
else
    emacsclient -c --eval '(org-tags-view t "computer+TODO=\"NEXT\"")' --eval '(delete-other-windows)'
    # emacsclient -c --eval '(org-tags-view t "computer")' --eval '(delete-other-windows)'
fi

# bash -c 'sleep 20; killall -w dropbox' &
