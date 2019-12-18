#!/bin/bash

# Elementary OS Post-Installation Script

# Turn off natural scrolling for trackpad

# elementary tweaks
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:philip.scott/elementary-tweaks
    sudo apt-get update
    sudo apt install elementary-tweaks

    sudo apt-get remove epiphany

# install fonts
    sudo apt-get install -y ttf-mscorefonts-installer --quiet
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    # cp -r ~/dotfiles/.fonts/  ~/.fonts/

#1. OS tweaks

 # - Turn off trackpad naturall scrolling
 # - 
 # - 
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme 'Transparent'
    gsettings set org.pantheon.desktop.gala.appearance button-layout 'windows'
    gsettings set org.gnome.mutter overlay-key "'Super_L'"
    gsettings set org.pantheon.desktop.gala.behavior overlay-action "'wingpanel --toggle-indicator=app-launcher'"

#2. # icons
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt-get update
    sudo apt-get install papirus-icon-theme
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'