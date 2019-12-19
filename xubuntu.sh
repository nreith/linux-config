#!/bin/bash

# Xubuntu config and installs

sudo apt install plank

# install fonts
    sudo apt-get install -y ttf-mscorefonts-installer --quiet
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    # cp -r ~/dotfiles/.fonts/  ~/.fonts/

# install icons

sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install papirus-icon-theme libreoffice-style-papirus

# install launcher

sudo apt install synapse

# STUCK HERE. Need to finish getting autoplank working. It runs.

# plank and autoplank
sudo apt install -y plank
sudo apt install -y golang-go xdotool dconf-cli
cd /tmp && git clone https://github.com/abiosoft/autoplank.git
cd autoplank && go build -o autoplank && sudo mv autoplank /usr/local/bin
