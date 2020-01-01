#!/bin/bash

# App Installs

# Usage:
# cd /tmp
# wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/nick_installs.sh
# sudo bash nick_installs.sh

cd /tmp
wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/install_functions.sh
source install_functions.sh

# installs
run_updates
install_common_cli
install_common_gui
config_locale_tz
install_anaconda3
install_azdatastudio
install_dbeaver
install_docker
install_java8
install_postman
install_pycharm
install_spotify
install_sublimetext
install_vscode
run_cleanup
