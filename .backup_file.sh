#!/bin/bash

folders='documents literature'
folders='documents music pictures literature'
dir=/d

if [ -d /media/oney/stuff/ ]; then
    dest=/media/oney/stuff
<<<<<<< HEAD
elif [ -d /media/oney/OneyCryptex/ ]; then
=======
elif [ -d /media/oney/Vault/ ]; then
>>>>>>> 38589e3c93c88ddad48ae42c10ea6ff2a1340329
    dest=/media/oney/Vault
fi

cd ~

cp -au ~/bin/zoterobib2* ~/zotero/
rsync -vurt --delete zotero/ /d/literature/zotero/

if [ 2 -eq `date +%w` ]; then
    rsync -vurtl --delete --size-only /stuff/vms/ $dest/vms/
fi

if [ -n $dest ]; then
    for f in ${folders}; do
        rsync -vurtl --delete ${dir}/${f}/ ${dest}/${f}/
    done
fi

# for the cryptex
if [ -d /media/oney/OneyCryptex/ ]; then
    echo "Everything looks good...";
    rsync -vurtCl --delete /d/documents/ /media/oney/OneyCryptex/documents/
    rsync -vurtl --delete ~ /media/oney/OneyCryptex/
    rsync -vurtRCl --delete .thunderbird/ /media/oney/OneyCryptex/
else echo "mount the partition first...";
fi

if [ -d /media/oney/stuff/ ]; then
    echo "Everything looks good...";
    rsync -vurtl --delete ~ $dest/
    rsync -vurtRCl --delete .thunderbird/ $dest/
    # for f in ${folders}; do
    #     rsync -vurtl --delete ${dir}/${f}/ ${dest}/${f}/
    # done
else echo "mount the partition first..."; 
fi
