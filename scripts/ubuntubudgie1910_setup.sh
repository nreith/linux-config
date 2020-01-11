#!/bin/bash

# Dependencies

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install \
  deja-dup \
  git \
  open-vm-tools \
  ubuntu-restricted-addons \
  ubuntu-restricted-extras \
  ufw gufw
sudo ufw enable

# Theme
sudo apt-get install breeze-cursor-theme
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'

sudo apt-get install papirus-icon-theme
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

cd /tmp && git clone https://github.com/hrdwrrsk/adementary-theme.git
cd adementary-theme && sudo ./install.sh
gsettings set org.gnome.desktop.interface gtk-theme 'Adementary'


