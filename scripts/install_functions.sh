#!/bin/bash

# updates
function updates() {
    sudo apt clean
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    }

# common
function install_common() {
    sudo apt install -y \
        build-essential \
	devhelp zeal \
	git \
        guake \
	firefox \
	chromium-browser \
	pass \
        python-pip \
        screenfetch \
	slack \
        ssh openssh-server \
        ubuntu-restricted-extras \
        transmission \
        neovim \
        zip unzip
    }

# Anaconda 3
function install_anaconda3() {
    cd /tmp && wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O Anaconda3-2019.10-Linux-x86_64.sh
    echo "46d762284d252e51cd58a8ca6c8adc9da2eadc82c342927b2f66ed011d1d8b53" Anaconda3-2019.10-Linux-x86_64.sh | sha256sum -c -
    sudo mkdir /opt/anaconda3
    bash Anaconda3-2019.10-Linux-x86_64.sh -b /opt/anaconda3
    sudo chown -R $USER:$USER /opt/anaconda3
    echo 'export PATH=$PATH:/opt/anaconda3/bin' >> ~/.bashrc
    source ~/.bashrc
    }

# Azure Data Studio
function install_azdatastudio() {
    sudo apt -y install libxss1 libgconf-2-4 libunwind8 
    cd /tmp && wget https://azuredatastudiobuilds.blob.core.windows.net/releases/1.13.1/azuredatastudio-linux-1.13.1.deb
    sudo dpkg -i azuredatastudio-linux-1.13.1.deb
    }

# chrome
function install_chrome() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt update 
    sudo apt install -y google-chrome-stable
    }

# dbeaver
function install_dbeaver() {
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    sudo add-apt-repository ppa:serge-rider/dbeaver-ce
    sudo apt update
    sudo apt install -y dbeaver-ce
    }

# docker
function install_docker() {
    sudo apt update
    sudo apt remove docker docker-engine docker.io
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt install -y docker.io
    sudo apt update
    sudo apt install -y docker-ce
    sudo usermod -aG docker $USER
    }

# free office
function install_freeoffice() {
    sudo apt remove libre-office # if installed
    cd /tmp && wget https://www.softmaker.net/down/softmaker-freeoffice-2018_973-01_amd64.deb
    sudo dpkg -i softmaker-freeoffice*.deb
    sudo /usr/share/freeoffice2018/add_apt_repo.sh
    }

# java 8
function install_java8() {
    sudo apt update
    sudo apt install -y openjdk-8-jdk
    }

# #postman
# function install_postman() {
# 	cd /tmp && wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz
# 	sudo tar -xvzf postman-linux-x64.tar.gz -C /opt
# 	mkdir ~/.local/share/applications && touch ~/.local/share/applications/postman2.desktop
# 	printf '[Desktop Entry]
# 	Name=Postman
# 	GenericName=API Client
# 	X-GNOME-FullName=Postman API Client
# 	Comment=Make and view REST API calls and responses
# 	Keywords=api;
# 	Exec=/opt/Postman/Postman
# 	Terminal=false
# 	Type=Application
# 	Icon=/opt/Postman/app/resources/app/assets/icon.png
# 	Categories=Development;Utilities;' > ~/.local/share/applications/postman2.desktop
# 	sudo ln -s /opt/Postman/Postman /usr/bin/postman
# }

# pycharm
function install_pycharm() {
    cd /tmp && wget https://download.jetbrains.com/python/pycharm-community-2019.3.tar.gz -O pycharm-community-2019.3.tar.gz
    sudo tar xfz pycharm-*.tar.gz -C /opt/
    cd /opt/pycharm-*/bin && ./pycharm.sh
    }

# spotify
function install_spotify() {
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update && sudo apt install -y spotify-client
    }

# Sublime text
function install_sublimetext() {
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update
    sudo apt install -y sublime-text
    }

function install_vbox_vagrant() {
    vagrant virtualbox dkms
    }

# vs code
function install_vscode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install -y code
    }

# clean up
function cleanup() {
    sudo apt-get update 
    sudo apt-get -y upgrade
    sudo apt-get clean
    sudo apt-get autoclean
    sudo apt-get autoremove
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    }
