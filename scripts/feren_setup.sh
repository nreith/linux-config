#!/bin/bash

# basics
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git wget neovim nano apt-transport-https

# apt-fast
sudo add-apt-repository ppa:apt-fast/stable
sudo apt-get update
sudo apt-get -y install apt-fast

# git setup
cd ~
mkdir -p git/pub
cd git/pub

# install scripts
git clone git@github.com:nreith/devops-scripts.git
cd devops-scripts/scriptsgit@github.com:nreith/devops-scripts.git

# cli tools
source install_cli_tools.sh
install_common_cli
install_bfg
install_anaconda3
install_docker
install_teradata_sql_drivers16
install_ms_sql_drivers17
install_vbox_vagrant

# gui tools
install_azdatastudio
install_chrome
install_dbeaver
install_vscode


