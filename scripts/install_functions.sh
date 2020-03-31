#!/bin/bash

# Data Science / Dev Ops Installs Script
#########################################

# One huge script to easily install/config commong Data Science / Dev Ops stuff
# + common desktop applications
# Known to work on Ubuntu 18.04 and derivatives, for example:
# (Ubuntu Server, Xubuntu, Lubuntu, Mate, Budgie, Pop!OS 18.04, Elementary OS 5.1 Hera, etc.)

# Usage:
########

# Paste the command below (without comment opener/closer into your command line)
# Then type one or more of the commands below in the index.

<< 'INSTRUCTIONS'

cd /tmp
wget "https://raw.githubusercontent.com/nreith/linux_config/master/scripts/install_functions.sh"
source install_functions.sh

INSTRUCTIONS

# Index:
########

# Pay attention to notes here. If you want alterations, run some function content manually.

<< 'INDEX'

##### CONFIG #####

run_updates
    # updates, upgrades, cleans up, etc. - run this first

run_cleanup
    # updates, upgrades, cleans, removes/autoremoves, and deletes temporary files and update lists
    # Especially useful if you\'re using this in a dockerfile to minimize bloat. Run this at the end of every RUN statement/layer

config_locale_tz
    # Stuff to get the Bash shell to stop screaming at you


##### COMMON CLI #####

install_common_cli
    # Some common cli tools like git, neovim, screenfetch + the basics of course

install_minimal_cli
    # Just the cli tools you probably need in a minimal setup like a docker image

install_anaconda3
    # Anaconda3-2019.10-Linux-x86_64.sh - also updates "conda" and "anaconda" to latest

install_docker
    # Docker - Note, this script enables sudo-less docker use so you don\'t have to type "sudo" for every docker command.

install_ms_mlserver_9.4.7
    # The full Microsoft ML Server install with compute node, web node, R 3.5.2 and Python 3.7.1

install_ms_mlserver_9.4.7_minimal_py_client
    # Just the bare minimum for an ML Server Python 3.7.1 client to communicate
    # with the full Microsoft ML Server

install_ms_sql_drivers17
    # ODBC v17 and JDBC v7 drivers for Microsoft SQL Server

install_open_java8
    # Java 8 - Still required by lots of things, even though it\'s old and we\'re on version 11.
    # I use openjdk because Oracle no longer allows you to download the file without a pain. Haven\'t noticed a difference.

install_oracle_java11
    # If you need the Oracle version, this is the latest. Version 8 is hard to get,
    # and no longer officially available

install_oracle_sql_drivers12
    # ODBC and JDBC drivers for Oracle SQL

install_teradata_sql_drivers16
    # ODBC v16 and JDBC v4 drivers for Teradata SQL

install_vbox_vagrant
    # Virtualbox + vagrant for scripting VMs

install_vmware_vagrant
    # VMWare Workstation Player + vagrant for scripting VMs - Free version = only 1 VM on at a time


##### COMMON GUI #####

install_common_gui
    # Commonly used things like browsers, etc.

install_azdatastudio
    # Azure Data Studio - my favorite SQL editor - only works with MS SQL Server

install_chrome
    # Gets real Google Chrome browser, not chromium-browser, the open-source knock-off

install_dbeaver
    # Dbeaver CE, the free community edition of the best multi-SQl, cross-platform SQL editor. Works with any SQL flavor

install_freeoffice
    # Free Office - A better, more Microsoft Office compatible version of Open Office. They split a while back over open-source purity

install_postman
    # Some Ubuntu-based distros have Postman in the app store. In case they don\'t, here you go

install_pycharm
    # In case you prefer the PyCharm IDE

install_spotify
    # Can\'t work without some tunes

install_sublimetext
    # I like sublime as a light-weight text-editor, more powerful than gedit, but less than a full IDE like VS Code

install_vscode
    # My preferred text editor/IDE - It\'s the most popular currently, so I'm in good company

INDEX

##############################################################################################################

##### CONFIG #####

# updates
function run_updates() {
    echo "Hold on. Getting some updates ..."
    sudo apt-get clean
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get autoremove -y
    }


# clean up
function run_cleanup() {
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
        bash-completion \
        build-essential \
        ca-certificates \
        curl wget \
        dialog \
	git \
        gnupg \
        file \
        iputils-ping \
        nano \
        neovim \ 
        net-tools \
	pass \
        python-pip \
        rsync \
        screenfetch neofetch \
        ssh openssh-server \
        ubuntu-restricted-extras \
        zip unzip
    }


function config_locale_tz() {
    echo "Configuring your time zone and locale... Chicago?"
    echo "Should automate lookup of this one day."
    sudo apt-get update
    sudo apt-get install -y  --no-install-recommends \
        tzdata \
        locales
    # Timezone / Locale stuff
    sudo ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
    sudo dpkg-reconfigure --frontend noninteractive tzdata
    sudo echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    sudo locale-gen en_US.UTF-8
    sudo update-locale LANG="en_US.UTF-8" LC_MESSAGES="POSIX"
    sudo dpkg-reconfigure --frontend noninteractive locales
}


##### COMMON CLI #####


function install_minimal_cli() {
    echo "Shell tools. Installing just the minimum..."
    echo "You must be using docker or something."
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        apt-utils \
        bash-completion \
        build-essential \
        ca-certificates \
        curl wget \
        dialog \
	git \
        nano \
        python-pip \
        ssh openssh-server \
        ubuntu-restricted-extras \
        zip unzip
}


# Anaconda 3
function install_anaconda3() {
    echo "You use Python too? Python 3 I hope!"
    echo "Note that we're installing in /opt/anaconda3 instead of /home/youruser/anaconda3"
    echo "This makes it available to everyone in multi-user situations."
    cd /tmp && wget "https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh" -O Anaconda3-2019.10-Linux-x86_64.sh
    echo "46d762284d252e51cd58a8ca6c8adc9da2eadc82c342927b2f66ed011d1d8b53" Anaconda3-2019.10-Linux-x86_64.sh | sha256sum -c -
    sudo mkdir -p /opt/anaconda3
    sudo bash Anaconda3-2019.10-Linux-x86_64.sh -b /opt/anaconda3/
    sudo chown -R $USER:$USER /opt/anaconda3
    export PATH=$PATH:/opt/anaconda3/bin
    echo "export PATH=\$PATH:/opt/anaconda3/bin" >> ~/.bashrc
    source ~/.bashrc
    conda update conda
    conda update anaconda
    }

# azure cli
function install_azcli() {
    sudo apt-get update
    sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | \
      sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
      sudo tee /etc/apt/sources.list.d/azure-cli.list
    sudo apt-get update
    sudo apt-get install azure-cli
    az login
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
    newgrp docker
    }


# microsoft mlserver 9.4.7
function install_ms_mlserver_9.4.7() {
    echo "Installing the complete Microsoft ML Server 9.4.7 with Python 3.7.1 and R 3.5.2"
    # Install as root
    sudo su
    # Optionally, if your system does not have the https apt transport option
    sudo apt-get install -yapt-transport-https
      # Add the **azure-cli** repo to your apt sources list
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
    # Set the location of the package repo the "prod" directory containing the distribution.
    # This example specifies 16.04. Replace with 14.04 if you want that version
    wget "https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb"
    # Register the repo
    sudo dpkg -i packages-microsoft-prod.deb
    # Verify whether the "microsoft-prod.list" configuration file exists
    ls -la /etc/apt/sources.list.d/
    # Add the Microsoft public signing key for Secure APT
    sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
    # Update packages on your system
    sudo apt-get update
    # Install the server
    sudo apt-get install -ymicrosoft-mlserver-all-9.4.7
    # Activate the server
    sudo /opt/microsoft/mlserver/9.4.7/bin/R/activate.sh     
    # List installed packages as a verification step
    sudo apt list --installed | grep microsoft  
    # Choose a package name and obtain verbose version information
    sudo dpkg --status microsoft-mlserver-packages-r-9.4.7
    # Turn off anonymous telemtry for MS ML Server
    sudo mlserver-python -c "import revoscalepy; revoscalepy.rx_privacy_control(False)"
    sudo su - -c "R -e \"rxPrivacyControl(TRUE)\""
    }


# microsoft mlserver 9.4.7 minimal python client
function install_ms_mlserver_9.4.7_minimal_py_client() {
    echo "Installing minimal Microsoft ML Server 9.4.7 with only Python 3.7.1 and no extra deps."
    echo "This is still huge at 3-5gb or larger. But much smaller than the full 15gb install."
    echo "If you must used MS ML Server but only need the client tools to connect to your server,"
    echo "This is the install for you. You may want to conda uninstall a bunch of packages too."
    # Install as root
    sudo su
    # Optionally, if your system does not have the https apt transport option
    sudo apt-get install -y apt-transport-https
      # Add the **azure-cli** repo to your apt sources list
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
    # Set the location of the package repo the "prod" directory containing the distribution.
    # This example specifies 16.04. Replace with 14.04 if you want that version
    wget "https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb"
    # Register the repo
    sudo dpkg -i packages-microsoft-prod.deb
    # Verify whether the "microsoft-prod.list" configuration file exists
    ls -la /etc/apt/sources.list.d/
    # Add the Microsoft public signing key for Secure APT
    sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
    # Update packages on your system
    sudo apt-get update
    # Install the server
    sudo apt-get install -y azure-cli \
        microsoft-mlserver-python-9.4.7 \
        microsoft-mlserver-packages-py-9.4.7
    # Activate the server
    sudo /opt/microsoft/mlserver/9.4.7/bin/R/activate.sh     
    # List installed packages as a verification step
    sudo apt list --installed | grep microsoft  
    # Choose a package name and obtain verbose version information
    sudo dpkg --status microsoft-mlserver-packages-r-9.4.7
    # Turn off anonymous telemtry for MS ML Server
    sudo mlserver-python -c "import revoscalepy; revoscalepy.rx_privacy_control(False)"
    sudo su - -c "R -e \"rxPrivacyControl(TRUE)\""
    }


# ms sql server odbc
function install_ms_sql_drivers17() {
    echo "Installing Microsoft SQL Server ODBC Driver v17 and JDBC Driver v7"
    # Build Deps
    apt-get update -y
    apt-get install -y sudo curl wget apt-transport-https gnupg gnupg1 gnupg2
    # MS SQL Server Drivers
    sudo curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    #Download appropriate package for the OS version
    #Choose only ONE of the following, corresponding to your OS version
    #Ubuntu 16.04
    #curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
    #Ubuntu 18.04
    sudo curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
    #Ubuntu 19.10
    #curl https://packages.microsoft.com/config/ubuntu/19.10/prod.list > /etc/apt/sources.list.d/mssql-release.list
    #exit
    sudo apt-get update
    sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
    # optional: for bcp and sqlcmd
    sudo ACCEPT_EULA=Y apt-get install mssql-tools
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
    source ~/.bashrc
    # optional: for unixODBC development headers
    sudo apt-get install -y unixodbc-dev
    # Get JDBC Driver
    cd /opt/microsoft && mkdir -p msjdbcsql7 && cd msjdbcsql7
    wget "https://github.com/Microsoft/mssql-jdbc/releases/download/v7.2.1/mssql-jdbc-7.2.1.jre8.jar"
    
    printf "
    [ODBC Driver 17 for SQL Server]
    Description=Microsoft ODBC Driver 17 for SQL Server
    Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.2.so.0.1
    Threading=1
    UsageCount=1

    [JDBC Driver 7 for SQL Server]
    Description=Microsoft JDBC Driver 7 for SQL Server
    Driver=/opt/microsoft/msjdbcsql7/mssql-jdbc-7.2.1.jre8.jar
    " >> /etc/odbcinst.ini
    }


# open java 8
function install_open_java8() {
    echo "Java 8. Open jdk. Here you go."
    sudo apt-get update
    sudo apt-get install -y openjdk-8-jdk
    }


# oracle java 11
function install_oracle_java11() {
    echo "Installing Oracle Java v11. v8 is no longer officially available."
    add-apt-repository ppa:linuxuprising/java
    apt-get update -y
    echo oracle-java11-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    apt-get install -y --no-install-recommends oracle-java11-installer
    apt-get install -yoracle-java11-set-default
}


# oracle sql odbc and jdbc
function install_oracle_sql_drivers12() {
    echo "Installing Oracle ODBC and JDBC Drivers v12.2"
    apt-get update -y
    apt-get install -y curl apt-transport-https unzip
    # Oracle Instantclient
    cd /tmp
    wget "https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-basic-linux.x64-12.2.0.1.0.zip"
    wget "https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-jdbc-linux.x64-12.2.0.1.0.zip"
    wget "https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-odbc-linux.x64-12.2.0.1.0.zip"
    wget "https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-sdk-linux.x64-12.2.0.1.0.zip"
    apt-get install -y --no-install-recommends libaio1
    unzip instantclient-basic-*
    unzip instantclient-jdbc-*
    unzip instantclient-odbc-*
    unzip instantclient-sdk-*
    mkdir -p /opt/oracle/
    mv instantclient_12_2 /opt/oracle/
    rm *.zip
    cd /opt/oracle/instantclient_12_2
    ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/libclntsh.so
    ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/libocci.so
    ln -s /opt/oracle/instantclient_12_2/libociei.so /opt/oracle/libociei.so
    ln -s /opt/oracle/instantclient_12_2/libnnz12.so /opt/oracle/libnnz12.so

    echo "export ORACLE_BASE=/usr/lib/instantclient_12_2" >> /home/$USER/.bashrc
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/oracle/instantclient_12_2" >> /home/$USER/.bashrc
    echo "export TNS_ADMIN=/opt/oracle/instantclient_12_2" >> /home/$USER/.bashrc
    echo "export ORACLE_HOME=/opt/oracle/instantclient_12_2" >> /home/$USER/.bashrc

    printf "
    [Oracle 12.2 ODBC driver]
    Description=Oracle ODBC driver for Oracle 12.2
    Driver = /opts/oracle/instantclient_12_2/ojdbc8.jar

    [Oracle 12.2 JDBC driver]
    Description=Oracle JDBC driver for Oracle 12.2
    Driver = /opts/oracle/instantclient_12_2/orai18n.jar
    " >> /etc/odbcinst.ini
    }


# teradata drivers v16.20
function install_teradata_drivers16() {
    echo "Installing Teradata ODBC and JDBC Drivers v16.20"
    # Teradata ODBC                                                                                                                   # TD
    cd /tmp
    wget "https://s3.amazonaws.com/stuff-for-devops/dbdrivers/tdodbc1620__ubuntu_indep.16.20.00.79-1.tar.gz"
    tar -xf tdodbc1620*.tar.gz
    sudo apt-get -f install -y --no-install-recommends lib32stdc++6 lib32gcc1 libc6-i386
    cd /tmp/tdodbc1620
    sudo dpkg -i tdodbc1620-16.20.00.79-1.noarch.deb

    # Teradata JDBC
    cd /tmp
    mkdir -p /opt/teradata
    mkdir -p /opt/teradata/jdbc
    wget "https://s3.amazonaws.com/stuff-for-devops/dbdrivers/Teradata/TeraJDBC__indep_indep.16.20.00.13.zip"
    unzip TeraJDBC*.zip
    rm TeraJDBC*.zip
    sudo mv terajdbc4.jar /opt/teradata/jdbc/
    wget "https://stuff-for-devops.s3.amazonaws.com/dbdrivers/Teradata/tdodbc1620__ubuntu_indep.16.20.00.90-1.tar.gz"
    sudo tar -xvf tdodbc1620*.tar.gz
    cd tdodbc1620
    sudo dpkg -i tdodbc*noarch.deb
    
    printf "
    [Teradata ODBC Driver 16.20]
    Description=Teradata Database ODBC Driver 16.20
    Driver=/opt/teradata/client/ODBC_64/lib/tdataodbc_sb64.so
    # Note: Currently, Data Direct Driver Manager does not support Connection Pooling feature.

    [Teradata JDBC Driver 4]
    Description=Teradata Database JDBC Driver 4
    Driver=/opt/teradata/jdbc/terajdbc4.jar
    " >> /etc/odbcinst.ini
    }


function install_vbox_vagrant() {
    echo "Virtualbox is better with Vagrant."
    virtualbox vagrant dkms
    }


function install_vmware_vagrant() {
    echo "VMWare is better if you pay for it. Vagrant makes it even better."
    cd /tmp
    wget "https://download3.vmware.com/software/player/file/VMware-Player-15.5.1-15018445.x86_64.bundle"
    sudo bash VMWare-Player*.bundle
    sudo apt-get install -yvagrant dkms
    }


##### COMMON GUI #####


function install_common_gui() {
    echo "Installing some common GUI packages"
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        guake \
        devhelp zeal \
        firefox chromium-browser install_chrome \
        install_slack \
        transmission
}

function install_slack() {
    echo "Installing Slack from .deb"
    sudo apt-get update
    sudo apt-get install gconf2 libappindicator1 libdbusmenu-gtk4
    cd /tmp && wget "https://downloads.slack-edge.com/linux_releases/slack-desktop-4.3.2-amd64.deb"
    sudo dpkg -i slack-desktop*.deb
}


# Azure Data Studio
function install_azdatastudio() {
    echo "Ah Azure Data Studio. So much nicer than that MSSSMS business. Code, don't right-click!"
    echo "Oh yeah, MSSSMS isn't available for Linux anyway."
    sudo apt-get -y install libxss1 libgconf-2-4 libunwind8 
    cd /tmp && wget "https://azuredatastudiobuilds.blob.core.windows.net/releases/1.13.1/azuredatastudio-linux-1.13.1.deb"
    sudo dpkg -i azuredatastudio-linux-1.13.1.deb
    }


# chrome
function install_chrome() {
    echo "Gotta have Chrome. But beware. It is slow as death on Linux inside of a VM guest!"
    wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c "echo "deb [arch=amd64] \"http://dl.google.com/linux/chrome/deb/ stable main\" >> /etc/apt/sources.list.d/google.list"
    sudo apt-get update 
    sudo apt-get install -y google-chrome-stable
    }


# dbeaver
function install_dbeaver() {
    echo "DBeaver, you're kind of ugly. But I like you."
    wget -O - "https://dbeaver.io/debs/dbeaver.gpg.key" | sudo apt-key add -
    echo "deb https://dbeaver.io/debs/dbeaver-ce" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    #sudo add-apt-repository ppa:serge-rider/dbeaver-ce
    sudo apt-get update
    sudo apt-get install -y dbeaver-ce
    }


# free office
function install_freeoffice() {
    echo "Meh. It's an office suite."
    sudo apt-get remove libre-office # if installed
    cd /tmp && wget "https://www.softmaker.net/down/softmaker-freeoffice-2018_973-01_amd64.deb"
    sudo dpkg -i softmaker-freeoffice*.deb
    sudo /usr/share/freeoffice2018/add_apt_repo.sh
    }


#postman
function install_postman() {
    echo "Postman. APIs are so much fun!"
	cd /tmp && wget "https://dl.pstmn.io/download/latest/linux64" -O postman-linux-x64.tar.gz
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
    cd /tmp && wget "https://download.jetbrains.com/python/pycharm-community-2019.3.tar.gz" -O pycharm-community-2019.3.tar.gz
    sudo tar xfz pycharm-*.tar.gz -C /opt/
    cd /opt/pycharm-*/bin && ./pycharm.sh
    }


# spotify
function install_spotify() {
    echo "Dooo dooo dooo dooo dooo... Spotify"
    curl -sS "https://download.spotify.com/debian/pubkey.gpg" | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install -y spotify-client
    }


# Sublime text
function install_sublimetext() {
    echo "Sublime Text 3. An oldie-but-goodie."
    wget -qO - "https://download.sublimetext.com/sublimehq-pub.gpg" | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install -y sublime-text
    }


# vs code
function install_vscode() {
    echo "Visual Studio Code. sudo apt-get install -yvscodium if you prefer the open-source version."
    curl "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y code
    }
