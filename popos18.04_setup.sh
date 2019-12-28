#!/bin/bash

cd /tmp
wget https://github.com/nreith/linux_config/raw/master/installs.sh
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
