#!/bin/bash

# Xubuntu config and installs

# install fonts
sudo apt-get install -y ttf-mscorefonts-installer --quiet
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
# cp -r ~/dotfiles/.fonts/  ~/.fonts/
sudo apt install -y fonts-open-sans fonts-roboto

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


# install launcher

sudo apt install synapse

# STUCK HERE. Need to finish getting autoplank working. It runs.

# plank and autoplank
sudo apt install -y plank
sudo apt install -y golang-go xdotool dconf-cli
cd /tmp && git clone https://github.com/abiosoft/autoplank.git
cd autoplank && go build -o autoplank && sudo mv autoplank /usr/local/bin
