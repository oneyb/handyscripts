#!/bin/bash

folders='documents literature'
folders='documents music pictures literature'
dir=/d
dest=/media/oney/Vault

cd ~

cp -au ~/bin/zoterobib2* ~/zotero/
rsync -vurt --delete zotero/ /d/literature/zotero/

if [ 2 -eq `date +%w` ]; then
    rsync -vurtl --delete --size-only /stuff/vms/ $dest/vms/
fi

for f in ${folders}
do
    # cp -r -u ${dir}/${f} ${dest}
    # rsync -vurtCl ${dir}/${f}/ ${dest}/${f}
    rsync -vurtl --delete ${dir}/${f}/ ${dest}/${f}/
done

# for the cryptex
if [ -d /media/oney/OneyCryptex/ ]; then
    echo "Everything looks good...";
    rsync -vurtCl --delete /d/documents/ /media/oney/OneyCryptex/documents/
    rsync -vurtl --delete ~ /media/oney/OneyCryptex/
    rsync -vurtRCl --delete .icedove/ /media/oney/OneyCryptex/
else echo "mount the partition first..."; exit;
fi

# Try to keep everything
# f=Videos
# rsync -vurtl ${dir}/${f}/ ${dest}/${f}/
# rsync -vurtl ${dir}/${f}/Movies/watchedMovies/ ${dest}/old/watchedMovies/
