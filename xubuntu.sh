#!/bin/bash

# Xubuntu config and installs

# install fonts
sudo apt-get install -y ttf-mscorefonts-installer --quiet
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
# cp -r ~/dotfiles/.fonts/  ~/.fonts/
sudo apt install -y fonts-open-sans fonts-roboto
cd /tmp && wget https://raw.githubusercontent.com/nreith/linux_config/master/googlefonts.sh
sudo bash googlefonts.sh
# install icons

sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install -y papirus-icon-theme libreoffice-style-papirus filezilla-theme-papirus

# stilo themes
sudo apt install -y gtk2-engines-murrine gtk2-engines-pixbuf fonts-roboto ninja-build git meson sassc
git clone https://github.com/lassekongo83/stilo-themes.git
cd stilo-themes
meson build
sudo ninja -C build -y install

# app and ds installs
cd /tmp && https://raw.githubusercontent.com/nreith/linux_config/master/installs.sh
source installs.sh
