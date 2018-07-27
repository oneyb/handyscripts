#!/bin/bash -x

docs=~/documents

# adb start-server
# adb wait-for-device

if [ "`adb devices | sed -r '/ice$/!d;s/^([[:alnum:]]+).*device$/\1/'`" == "4200f424d44d5200" ];
then
    echo syncing phone
    phone=1
    storage_ext=rsync://localhost:6010/root/storage/extSdCard
    storage_pho=rsync://localhost:6010/root/sdcard
elif [ "`adb devices | sed -r '/ice$/!d;s/^([[:alnum:]]+).*device$/\1/'`" == "42008f25d41da4fb" ];
then
    echo syncing new phone
    phone=0
    storage_ext=/storage/6FAA-E43C
    storage_pho=/storage/self/primary
fi

# if [[ ! -f ~/phone/rsync.bin ]]; then
#     wget -O ~/phone/rsync.bin http://github.com/pts/rsyncbin/raw/master/rsync.rsync4android
# fi

# adb push ~/phone/rsync.bin /data/local/tmp/rsync
# adb shell chmod 755 /data/local/tmp/rsync

# adb shell 'exec >/sdcard/rsyncd.conf && echo address = 127.0.0.1 && echo port = 1873 && echo "[root]" && echo path = / && echo use chroot = false && echo read only = false'
# # adb shell '/data/local/tmp/rsync --daemon --config=/sdcard/rsyncd.conf --log-file=/data/local/tmp/foo &'

# adb shell /data/local/tmp/rsync --daemon --no-detach --config=/sdcard/rsyncd.conf --log-file=/proc/self/fd/2 &
# adb forward tcp:6010 tcp:1873

echo Syncing...
sleep 1
if [[ $# -eq 0 ]] | [[ $1 != "in" ]]; then
    # Stuff to sync
    # stuff="documents/config documents/marriage documents/training_tourenleiter action books dropbox-insekten/Dropbox org org-archive zotero rpi-ap-ha Dropbox/wedding-planning"
    stuff="Sync books github gebastel"
    for s in $stuff; do
        adb-sync -n --delete ~/$s/ $storage_ext/$(basename $s)/
    done

    # Musica!
    # if [[ $phone -eq 1 ]]; then
    adb-sync -n --delete ~/music/essence/ $storage_ext/music/
    adb-sync -n --delete ~/music/meditation/s.n.-goenka/ $storage_ext/music/s.n.-goenka/
    # else
    #     rsync -vrulDO --size-only --delete ~/music/faves/ $storage_ext/music/faves/
    # fi

    # Pix
    adb-sync -n -R $storage_ext/DCIM/Camera/ $HOME/pictures/phone/
    adb-sync -n -R $storage_pho/WhatsApp/Media/WhatsApp*/ $HOME/pictures/phone/
    adb-sync -n $storage_ext/{C,K}o* $HOME/documents/contacts/
    if [[ $phone -eq 1 ]]; then
        adb-sync -n $storage_pho/{C,K}o* $HOME/documents/contacts/
    fi

    # Scans
# else
#     # stuff="eaternity"
#     stuff="jobsearch marriage training_tourenleiter"
#     for s in $stuff; do
#         rsync -vurt --delete $storage_ext/$s/ $docs/$s/
#     done

#     # Action, Books
#     # stuff="action books vipassana Breeding dropbox-insekten/Dropbox"
#     stuff="action books Breeding sia-thesis sia-manuscript zotero"
#     for s in $stuff; do
#         rsync -vurt --delete $storage_ext/$s/ ~/$s/
#     done
fi

# sleep 6

# adb forward --remove tcp:6010
# adb shell rm -f /sdcard/rsyncd.conf
# adb shell rm -f /data/local/tmp/rsync
adb kill-server
echo Phone can now be removed

