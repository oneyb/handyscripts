#!/bin/bash -x

docs=~/documents

adb start-server
adb wait-for-device

if [ "`adb devices | sed -r '/ice$/!d;s/^([[:alnum:]]+).*device$/\1/'`" == "4200f424d44d5200" ];
then
    echo syncing phone
    phone=1
    USB=rsync://localhost:6010/root/storage/extSdCard
    USB1=rsync://localhost:6010/root/sdcard
else
    echo syncing tablet
    phone=0
    USB=rsync://localhost:6010/root/storage/2601-20A9
    USB1=rsync://localhost:6010/root/storage/sdcard
fi

if [[ ! -f ~/phone/rsync.bin ]]; then
    wget -O ~/phone/rsync.bin http://github.com/pts/rsyncbin/raw/master/rsync.rsync4android
fi

adb push ~/phone/rsync.bin /data/local/tmp/rsync
adb shell chmod 755 /data/local/tmp/rsync

adb shell 'exec >/sdcard/rsyncd.conf && echo address = 127.0.0.1 && echo port = 1873 && echo "[root]" && echo path = / && echo use chroot = false && echo read only = false'
# adb shell '/data/local/tmp/rsync --daemon --config=/sdcard/rsyncd.conf --log-file=/data/local/tmp/foo &'

adb shell /data/local/tmp/rsync --daemon --no-detach --config=/sdcard/rsyncd.conf --log-file=/proc/self/fd/2 &
adb forward tcp:6010 tcp:1873

echo Syncing...
sleep 1

if [[ $# -eq 0 ]] | [[ $1 != "in" ]]; then
    # Stuff to sync
    stuff="jobsearch config pubmaterials marriage training_tourenleiter"
    for s in $stuff; do
        rsync -vrulDO --size-only --exclude '*bw2-py*' --delete $docs/$s/ $USB/$s/
    done

    # Home stuff
    stuff="action books Breeding dropbox-insekten/Dropbox sia-thesis sia-manuscript org"
    for s in $stuff; do
        rsync -vrulDOL --size-only --delete ~/$s/ $USB/$s/
    done

    # Musica!
    if [[ $phone -eq 1 ]]; then
        rsync -vrulDO --size-only --delete ~/music/essence/ $USB/music/
    else
        rsync -vrulDO --size-only --delete ~/music/faves/ $USB/music/faves/
    fi

    # Pix
    rsync -vrulDO --size-only --delete $USB/DCIM/Camera/* $HOME/pictures/phone/
    rsync -vrulDO --size-only --delete "$USB1/WhatsApp/Media/WhatsApp Images/*jpg" $HOME/pictures/phone/
    if [[ $phone -eq 1 ]]; then
        # rsync -vrulDO --size-only $USB1/Contact* $HOME/documents/contacts/
        # rsync -vrulDO --size-only $USB1/{C,K}o* $HOME/documents/contacts/
        rsync -vrulDO --size-only $USB/{C,K}o* $HOME/documents/contacts/
    fi

    # Scans
    rsync -vrulDO --size-only $USB1/ClearScanner_PDF/* $HOME/documents/scans/
else
    # stuff="eaternity"
    stuff="jobsearch pubmaterials marriage training_tourenleiter"
    for s in $stuff; do
        rsync -vurt --delete $USB/$s/ $docs/$s/
    done

    # # Action, Books
    # stuff="action books vipassana Breeding dropbox-insekten/Dropbox"
    stuff="action books Breeding dropbox-insekten/Dropbox sia-thesis sia-manuscript org"
    for s in $stuff; do
        rsync -vurt --delete $USB/$s/ ~/$s/
    done

fi

sleep 6

adb forward --remove tcp:6010
adb shell rm -f /sdcard/rsyncd.conf
adb shell rm -f /data/local/tmp/rsync
adb kill-server
echo Phone can now be removed
