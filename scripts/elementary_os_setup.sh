#!/bin/bash

# Get path function needed here.

# Elementary OS Post-Installation Script

sudo apt-get remove epiphany-browser

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

 # - Turn off trackpad naturall scrolling -manually. need to script
 
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme 'Transparent'
    gsettings set org.pantheon.desktop.gala.appearance button-layout 'windows'
    gsettings set org.gnome.mutter overlay-key "'Super_L'"
    gsettings set org.pantheon.desktop.gala.behavior overlay-action "'wingpanel --toggle-indicator=app-launcher'"

#2. # icons
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt-get update
    sudo apt-get install papirus-icon-theme
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

#3. Quicktile
    cd /tmp
    wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/quicktile_elementary_os.sh
    sudo bash quicktile_elementary _os.sh

#4. App Installs

cd /tmp
wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/installs.sh
source installs.sh

# installs
updates
install_common
install_anaconda3
install_azdatastudio
install_dbeaver
install_docker
install_java8
install_pycharm
install_spotify
install_sublimetext
install_vscode
cleanup
