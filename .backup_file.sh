#!/bin/bash


# if [ "23e07b94-b859-4ead-914c-a8f763120cea" == $(sed -r '/^#/d;/\s\/\s/!d;s/^UUID=([a-z0-9-]+) .+$/\1/' /etc/fstab) ]; then
if [ $HOST == "tinkbox" ]; then
    folders='/d/documents /d/literature'
else
    folders='/e/documents /d/music /d/pictures /d/literature'
fi

if [ -d /media/oney/stuff/ ]; then
    dest=/media/oney/stuff
elif [ -d /media/oney/Vault/ ]; then
    dest=/media/oney/Vault
elif [ -d /media/oney/cryptex/ ]; then
    dest=/media/oney/cryptex
fi

cd ~


if [ -n $dest ]; then
    for f in ${folders}; do
        rsync -vurtl --delete ${f}/ ${dest}/$(basename ${f})/
    done
fi

if [ -d /media/oney/cryptex/ ]; then
    rsync -vurtl --delete ~ $dest/
    rsync -vurtl --delete --size-only /stuff/ $dest/stuff/
fi
if [ $HOST != "tinkbox" ]; then
    rsync -vurtl --delete zotero/ $dest/zotero/
    rsync -vurtl --delete /stuff/academic-archive/ $dest/academic-archive/
    if [ 2 -eq `date +%w` ]; then
        rsync -vurtl --delete --size-only /stuff/vms/ $dest/vms/
    fi
fi

# for the cryptex
if [ -d /media/oney/OneyCryptex/ ]; then
    echo "Everything looks good...";
    rsync -vurtl --delete $dir/documents/ /media/oney/OneyCryptex/documents/
    rsync -vurtl --delete ~ /media/oney/OneyCryptex/
    # rsync -vurtRCl --delete .thunderbird/ /media/oney/OneyCryptex/
else echo "mount the /media/oney/OneyCryptex/ partition first...";
fi

if [ -d /media/oney/stuff/ ]; then
    echo "Everything looks good...";
    rsync -vurtl --delete ~ $dest/
    # for f in ${folders}; do
    #     rsync -vurtl --delete ${dir}/${f}/ ${dest}/${f}/
    # done
else echo "mount the /media/oney/stuff/partition first..."; 
fi
