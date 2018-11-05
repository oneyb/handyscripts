#!/bin/bash -x

docs=~/documents

# xmessage -timeout 1  "Files are conflicted"  --display=:0 
# touch /home/oney/shivermetimbers
# exit 

adb start-server
adb wait-for-device

if [ "`adb devices | sed -r '/ice$/!d;s/^([[:alnum:]]+).*device$/\1/'`" == "4200f424d44d5200" ];
then
    echo syncing phone
    phone=1
    storage_ext=/storage/extSdCard
    storage_pho=/storage/sdcard
elif [ "`adb devices | sed -r '/ice$/!d;s/^([[:alnum:]]+).*device$/\1/'`" == "42008f25d41da4fb" ];
then
    echo syncing new phone
    phone=0
    storage_ext=/storage/6FAA-E43C
    storage_pho=/storage/emulated/0
fi

echo Syncing...
sleep 1
if [[ $# -eq 0 ]] | [[ $1 != "in" ]]; then
    # Stuff to sync
    stuff="books github gebastel documents/training_tourenleiter"
    for s in $stuff; do
        adb-sync --force --copy-links --delete ~/$s/ $storage_ext/$(basename $s)/
    done

    if [[ $phone -eq 0 ]]; then
        adb-sync -n --delete ~/music/essence/ $storage_ext/music/essence/
    else
        adb-sync -n --delete ~/music/faves/ $storage_ext/music/faves/
    fi
    adb-sync -n --delete ~/music/meditation/s.n.-goenka/ $storage_ext/music/s.n.-goenka/

    # Pix
    adb-sync -R $storage_ext/DCIM/Camera/ $HOME/pictures/phone/
    adb-sync -R $storage_pho/WhatsApp/Media/WhatsApp*/ $HOME/pictures/phone/
    adb-sync $storage_ext/{C,K}o* $HOME/documents/contacts/
    adb-sync $storage_pho/{C,K}o* $HOME/documents/contacts/

    # Syncthing stuff
    stman folder list | sed -r '/Folder Path/!d' | awk '{print $3}' | while read d;
    do
        adb-sync --force --copy-links --delete $d $storage_ext/$(basename $d)/
        [[ $? -ne 0 ]] && echo ooops....
    done
fi

adb shell touch $storage_ext/test.txt
adb kill-server
echo Phone can now be removed 
