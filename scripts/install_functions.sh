#!/bin/bash

# About this script:
####################

# One huge script to make it easy to install anything for DevOps/Data Science
# As well as some other commonly used desktop applications
# Known to work on Ubuntu 18.04 and derivatives
# (Ubuntu Server, Xubuntu, Lubuntu, Mate, Budgie, Pop!OS 18.04, Elementary OS 5.1 Hera, etc.)

# Usage:
########

# Paste the command below (without comment opener/closer into your command line)
# Then type one or more of the commands below in the index.

<< 'INSTRUCTIONS'

cd /tmp
wget https://raw.githubusercontent.com/nreith/linux_config/master/scripts/install_functions.sh
source install_functions.sh

INSTRUCTIONS

# Index:
########

# Pay attention to notes here, and run the code inside functions manually if you want to make alterations

<< 'INDEX'

run_updates
	# updates, upgrades, cleans up, etc. - run this first
run_cleanup
    # updates, upgrades, cleans, removes/autoremoves, and deletes temporary files and update lists
    # Especially useful if you\'re using this in a dockerfile to minimize bloat. Run this at the end of every RUN statement/layer
config_locale_tz
    # Stuff to get the Bash shell to stop screaming at you

######

install_common_cli
    # Some common cli tools like git, neovim, screenfetch + the basics of course
install_minimal_cli
    # Just the cli tools you probably need in a minimal setup like a docker image
install_common_gui
	# Commonly used things like browsers, etc.

######

install_anaconda3
	# Anaconda3-2019.10-Linux-x86_64.sh - also updates "conda" and "anaconda" to latest
install_azdatastudio
	# Azure Data Studio - my favorite SQL editor - only works with MS SQL Server
install_chrome
	# Gets real Google Chrome browser, not chromium-browser, the open-source knock-off
install_dbeaver
	# Dbeaver CE, the free community edition of the best multi-SQl, cross-platform SQL editor. Works with any SQL flavor
install_docker
	# Docker - Note, this script enables sudo-less docker use so you don\'t have to type "sudo" for every docker command.
install_freeoffice
	# Free Office - A better, more Microsoft Office compatible version of Open Office. They split a while back over open-source purity
install_java8
	# Java 8 - Still required by lots of things, even though it\'s old and we\'re on version 11.
	# I use openjdk because Oracle no longer allows you to download the file without a pain. Haven\'t noticed a difference.
install_postman
	# Some Ubuntu-based distros have Postman in the app store. In case they don\'t, here you go
install_pycharm
    # In case you prefer the PyCharm IDE
install_spotify
	# Can\'t work without some tunes
install_sublimetext
    # I like sublime as a light-weight text-editor, more powerful than gedit, but less than a full IDE like VS Code
install_vbox_vagrant
	# Virtualbox + vagrant for scripting VMs
install_vmware_vagrant
	# VMWare Workstation Player + vagrant for scripting VMs - Free version = only 1 VM on at a time
install_vscode
    # My preferred text editor/IDE - It\'s the most popular currently, so I'm in good company

INDEX

##############################################################################################################

# updates
function updates() {
    echo "Hold on. Getting some updates ..."
    sudo apt-get clean
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get autoremove -y
    }

# clean up
function cleanup() {
    echo "Let's tidy this place up a bit, shall we?"
    sudo apt-get update 
    sudo apt-get -y upgrade
    sudo apt-get clean
    sudo apt-get autoclean
    sudo apt-get autoremove
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    }

# common
function install_common_cli() {
    echo "Shell tools. Installing the usual suspects"
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        apt-utils \
        bash-completion `so nice to have your thoughts finished for you` \
        build-essential \
        ca-certificates `auth stuff for ssl, etc.` \
        curl wget `both for file downloads` \
        dialog `useful user dialogs` \
	    git `don\'t leave home without it` \
        gnupg \
        file `recognizes filetype` \
        iputils-ping `network testing` \
        nano `easy command-line text editor` \
        neovim `nicer than vim in my opinion` \ 
        net-tools `ifconfig, etc.` \
	    pass \
        python-pip \
        rsync `to sync/backup files local or remote`\
        screenfetch `show off your distro!` \
        ssh openssh-server `work on your docker/server remotely` \
        ubuntu-restricted-extras \
        zip unzip `pesky zip files`
    }


function install_minimal_cli() {
    echo "Shell tools. Installing just the minimum..."
    echo "You must be using docker or something."
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        apt-utils \
        bash-completion `so nice to have your thoughts finished for you` \
        build-essential \
        ca-certificates `auth stuff for ssl, etc.` \
        curl wget `both for file downloads` \
        dialog `useful user dialogs` \
	    git `don\'t leave home without it` \
        nano `easy command-line text editor` \
        python-pip \
        ssh openssh-server `work on your docker/server remotely` \
        ubuntu-restricted-extras \
        zip unzip `pesky zip files`
}


function config_locale_tz() {
    echo "Configuring your time zone and locale... Chicago?"
    echo "Should automate lookup of this one day."
    sudo apt-get update
    sudo apt-get install -y  --no-install-recommends \
        tzdata `time zones` \
        locales `internationalization`
    # Timezone / Locale stuff
    ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen en_US.UTF-8
    update-locale LANG="en_US.UTF-8" LC_MESSAGES="POSIX"
    dpkg-reconfigure --frontend noninteractive locales
}

function install_common_gui() {
    echo "Installing some common GUI packages"
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        guake `Drop-down terminal` \
        devhelp zeal `Documentation for coding` \
	    firefox chromium-browser install_chrome `various browsers` \
        slack `communication`\
        transmission `torrents client`
}

# Anaconda 3
function install_anaconda3() {
    echo "You use Python too? Python 3 I hope!"
    echo "Note that we're installing in /opt/anaconda3 instead of /home/youruser/anaconda3"
    echo "This makes it available to everyone in multi-user situations."
    cd /tmp && wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O Anaconda3-2019.10-Linux-x86_64.sh
    echo "46d762284d252e51cd58a8ca6c8adc9da2eadc82c342927b2f66ed011d1d8b53" Anaconda3-2019.10-Linux-x86_64.sh | sha256sum -c -
    sudo mkdir /opt/anaconda3
    bash Anaconda3-2019.10-Linux-x86_64.sh -b /opt/anaconda3
    sudo chown -R $USER:$USER /opt/anaconda3
    echo 'export PATH=$PATH:/opt/anaconda3/bin' >> ~/.bashrc
    source ~/.bashrc
    conda update conda
    conda update anaconda
    }

# Azure Data Studio
function install_azdatastudio() {
    echo "Ah Azure Data Studio. So much nicer than that MSSSMS business. Code, don't right-click!"
    echo "Oh yeah, MSSSMS isn't available for Linux anyway."
    sudo apt-get -y install libxss1 libgconf-2-4 libunwind8 
    cd /tmp && wget https://azuredatastudiobuilds.blob.core.windows.net/releases/1.13.1/azuredatastudio-linux-1.13.1.deb
    sudo dpkg -i azuredatastudio-linux-1.13.1.deb
    }

# chrome
function install_chrome() {
    echo "Gotta have Chrome. But beware. It is slow as death on Linux inside of a VM guest!"
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update 
    sudo apt-get install -y google-chrome-stable
    }

# dbeaver
function install_dbeaver() {
    echo "DBeaver, you're kind of ugly. But I like you."
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    sudo add-apt-repository ppa:serge-rider/dbeaver-ce
    sudo apt-get update
    sudo apt-get install -y dbeaver-ce
    }

# docker
function install_docker() {
    echo "Docker. Not Dockers."
    sudo apt-get update
    sudo apt-get remove docker docker-engine docker.io
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt-get install -y docker.io
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $USER
    }

# free office
function install_freeoffice() {
    echo "Meh. It's an office suite."
    sudo apt-get remove libre-office # if installed
    cd /tmp && wget https://www.softmaker.net/down/softmaker-freeoffice-2018_973-01_amd64.deb
    sudo dpkg -i softmaker-freeoffice*.deb
    sudo /usr/share/freeoffice2018/add_apt_repo.sh
    }

# java 8
function install_java8() {
    echo "Java 8. Here you go."
    sudo apt-get update
    sudo apt-get install -y openjdk-8-jdk
    }

#postman
function install_postman() {
    echo "Postman. APIs are so much fun!"
	cd /tmp && wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz
	sudo tar -xvzf postman-linux-x64.tar.gz -C /opt
	mkdir ~/.local/share/applications && touch ~/.local/share/applications/postman2.desktop
	printf '[Desktop Entry]
	Name=Postman
	GenericName=API Client
	X-GNOME-FullName=Postman API Client
	Comment=Make and view REST API calls and responses
	Keywords=api;
	Exec=/opt/Postman/Postman
	Terminal=false
	Type=Application
	Icon=/opt/Postman/app/resources/app/assets/icon.png
	Categories=Development;Utilities;' > ~/.local/share/applications/postman2.desktop
	sudo ln -s /opt/Postman/Postman /usr/bin/postman
}

# pycharm
function install_pycharm() {
    echo "PyCharm. JetBrains? What kind of name is that?"
    cd /tmp && wget https://download.jetbrains.com/python/pycharm-community-2019.3.tar.gz -O pycharm-community-2019.3.tar.gz
    sudo tar xfz pycharm-*.tar.gz -C /opt/
    cd /opt/pycharm-*/bin && ./pycharm.sh
    }

# spotify
function install_spotify() {
    echo "Dooo dooo dooo dooo dooo... Spotify"
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install -y spotify-client
    }

# Sublime text
function install_sublimetext() {
    echo "Sublime Text 3. An oldie-but-goodie."
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install -y sublime-text
    }

function install_vbox_vagrant() {
    echo "Virtualbox is better with Vagrant."
    virtualbox vagrant dkms
    }

function install_vmware_vagrant() {
    echo "VMWare is better if you pay for it. Vagrant makes it even better."
    cd /tmp
    wget https://download3.vmware.com/software/player/file/VMware-Player-15.5.1-15018445.x86_64.bundle
    sudo bash VMWare-Player*.bundle
    sudo apt-get install vagrant dkms
    }

# vs code
function install_vscode() {
    echo "Visual Studio Code. sudo apt-get install vscodium if you prefer the open-source version."
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install -y code
    }
