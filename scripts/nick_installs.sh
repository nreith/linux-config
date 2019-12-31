#!/bin/bash

# App Installs

# Usage:
# cd /tmp
# wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/nick_installs.sh
# sudo bash nick_installs.sh

cd /tmp
wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/install_functions.sh
source app_install_functions.sh

# installs
updates
install_common
install_anaconda3
install_azdatastudio
install_chrome
install_dbeaver
install_docker
install_java8
install_postman
install_pycharm
install_spotify
install_sublimetext
install_vscode
cleanup
