#!/bin/bash -x

cd ~

# The bare essentials

sudo apt-get install android-tools-adb android-tools-fastboot htop aspell       \
      aspell-bg aspell-de aspell-en aspell-es audacity automake awesome         \
      awesome-extra build-essential calendar-google-provider calibre chromium   \
      cmake cmake-data cryptsetup-bin cups curl dash evince firefox-esr         \
      firmware-linux-free firmware-linux-nonfree flac flashplugin-nonfree       \
      freecad gdal-bin genisoimage geoip-database gfortran gimp git             \
      gnome-disk-utility gocr gocr-tk googleearth-package gparted handbrake     \
      handbrake-cli imagemagick inkscape ispell java-common lame laptop-detect  \
      mencoder mplayer2 nco ncview netcdf-bin netcdf-doc ntfs-3g ntfs-config    \
      openssh-client openssh-server p7zip-full pavucontrol pcmanfm pdftk        \
      proj-bin proj-data pulseaudio pulseaudio-module-x11 pulseaudio-utils      \
      qpdf qpdfview r-base r-cran-xml2 r-cran-ncdf4 recordmydesktop ristretto   \
      rsync scrot seahorse simple-scan smplayer subversion suckless-tools       \
      synaptic tor tor-arm tor-geoipdb torsocks transmission-gtk trash-cli      \
      udevil unattended-upgrades unoconv vim-gtk wget epiphany-browser          \
      bleachbit wodim wordnet xbindkeys xclip xdg-user-dirs xdg-utils xdotool   \
      xfburn xpdf xsel xul-ext-firebug xul-ext-itsalltext xul-ext-monkeysphere  \
      xul-ext-noscript libssl-dev libgdal-dev libmariadb-client-lgpl-dev        \
      exfat-utils libxft-dev libfreetype6-dev


# python packages
sudo apt-get install python-xdg ipython ipython3 pyflakes python python-cups  \
      python-cupshelpers python-flake8 python-libxml2 python-matplotlib       \
      python-numpy python-openpyxl python-openssl python-pandas               \
      python-jsonrpclib python-pyparsing python-scipy python-setuptools       \
      python-simplejson python-unittest2 python3 python-gdal python-pdfminer  \
      pdfminer-data python-pip python-pip3 ipython-notebook ipython3-notebook

# sudo pip install pandas ggplot
sudo chmod 755 -R /usr/local/lib

# Playonlinux!!
# wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
# sudo wget http://deb.playonlinux.com/playonlinux_wheezy.list -O /etc/apt/sources.list.d/playonlinux.list
# sudo apt-get update
# sudo apt-get install playonlinux

## Set default programs
sudo update-alternatives --config x-www-browser
# sudo update-alternatives --config gnome-www-browser
sudo update-alternatives --config editor
# setxkbmap -option "compose:caps"

# sudo cat "deb http://download.virtualbox.org/virtualbox/debian jessie contrib" >> /etc/apt/sources.list
# wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
# sudo apt-get update
# sudo apt-get install virtualbox-5.1


curl -O http://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
sudo cp rclone /usr/sbin/
sudo chown root:root /usr/sbin/rclone
sudo chmod 755 /usr/sbin/rclone
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb

pkgs=(
    https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb
)

function install_manual_deb ()
{
        wget $1
        sudo dpkg -i `basename $1`
        if [ $# -eq 0 ]; then
            sudo apt-get install -f
        fi
        mv `basename $1` $HOME/bin/src/
}

for p in ${pkgs[@]}; do
    install_manual_deb $p
done

# Messenger services with Franz
wget https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-4.0.4.tgz
sudo mkdir /opt/franz
sudo tar xzf Franz-linux*.tgz -C /opt/franz
sudo ln -s /opt/franz/Franz /usr/bin/franz
sudo wget https://cdn-images-1.medium.com/max/360/1*v86tTomtFZIdqzMNpvwIZw.png -O /usr/share/icons/franz.png
sudo bash -c "echo -e \"[Desktop Entry]\nEncoding=UTF-8\nName=Franz\nComment=A free messaging app for WhatsApp, Facebook Messenger, Telegram, Slack and more.\nExec=franz -- %u\nStartupWMClass=Franz\nIcon=franz\nTerminal=false\nType=Application\nCategories=Network;\" > /usr/share/applications/franz.desktop"
mv Franz-linux*.tgz $HOME/bin/src/

# # Don't telegram anymore
# wget https://updates.tdesktop.com/tlinux/tsetup.0.10.19.tar.xz
# mv tsetup.0.10.19.tar.xz /home/oney/bin/src/
# cd  /home/oney/bin/src/
# tar xJf tsetup.0.10.19.tar.xz
# mv Telegram/* ~/bin/src/
# rmdir Telegram

wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libgtk2.0-0:i386 libxml2:i386 libstdc++6:i386
sudo dpkg -i AdbeRdr9*.deb
mv AdbeRdr9*.deb ~/bin/src/

# archwiki
wget https://www.archlinux.org/packages/community/any/arch-wiki-docs/download/ -O arch-wiki-docs.tar.xz
sudo tar xJf arch-wiki-docs.tar.xz -C /
wget https://www.archlinux.org/packages/community/any/arch-wiki-lite/download/ -O arch-wiki-lite.tar.xz
sudo tar xJf arch-wiki-lite.tar.xz -C /
mv arch-wiki* ~/bin/src/
sudo rm /.BUILDINFO /.MTREE /.PKGINFO

# # PDF-tools awesomeness
# sudo aptitude install libpng-dev libz-dev libpoppler-glib-dev  \
#      libpoppler-private-dev
# git clone https://github.com/politza/pdf-tools
# cd pdf-tools
# # make install-server-deps # optional
# make -s
# if [ -f pdf-tools-*.tar ]; then
#    sudo make install-package
# fi
# make clean
# cd ..
# mv pdf-tools ~/bin/src/
echo "much easier to install pdf-tools layer and then:"
emacsclient -e "(pdf-tools-install)"

# Nice grub screen hiding
wget https://raw.githubusercontent.com/hobarrera/grub-holdshift/master/31_hold_shift -O /etc/grub.d/31_hold_shift
sudo bash -c 'echo -e "GRUB_TIMEOUT=\"0\"\nGRUB_HIDDEN_TIMEOUT=\"0\"\nGRUB_FORCE_HIDDEN_MENU=\"true\"" >> /etc/default/grub'
grub-mkconfig -o /boot/grub/grub.cfg

# emacs as service: from http://blog.refu.co/?p=1296
mkdir -p ~/.config/systemd/user/
echo -e  "[Unit]\n\nDescription=Emacs: the extensible, self-documenting text editor\n\n[Service]\n\nType=forking\nExecStart=/usr/bin/emacs --daemon\nExecStop=/usr/bin/emacsclient --eval \"(progn (save-buffers-kill-emacs))\"\nRestart=always\n# Remove the limit in startup timeout, since emacs\n# cloning and building all packages can take time\nTimeoutStartSec=0\n\n[Install]\n\nWantedBy=default.target" > ~/.config/systemd/user/emacs.service
systemctl --user enable emacs
bash -c 'systemctl --user start emacs'
# systemctl --user stop emacs
# systemctl --user disable emacs

# # skype
# wget https://www.skype.com/de/download-skype/skype-for-linux/downloading/?type=debian32 -O skype-`date +%F`.deb
# dpkg -i skype-`date +%F`.deb
# agi -f/etc/defaults/grub
# mv skype-`date +%F`.deb ~/bin/src/


# For LaTeX
if [ -d /media/oney/stuff/texlive/ ];
then
    sudo cp -r /media/oney/stuff/texlive/ /usr/local/src/
else
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar xzf install-tl-unx.tar.gz
    cd install-tl*
    TEXLIVE_INSTALL_PREFIX=$HOME/texlive/
    ./install-tl -portable
fi
echo -e "if [ -d /usr/local/src/texlive/ ]; then\n\tPATH=\"/usr/local/src/texlive/bin/$(uname -m)-$(uname -s | sed "s/.*/\L&/"):\$PATH\"\nfi"


# May change this
echo "Wanna? sudo localectl set-x11-keymap us pc105 qwerty 'compose:102'"
echo "Wanna? sudo localectl set-x11-keymap us pc105 qwerty 'compose:prsc,caps:escape'"
