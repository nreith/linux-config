#!/bin/bash

# Setup keyboard window tiling for Elementary OS

# Installs quicktile (https://github.com/ssokolow/quicktile) 
# for Elementary OS 5.1 Hera (https://elementary.io/)
# based on Ubuntu 18.04 LTS (http://releases.ubuntu.com/18.04/)
# with required hacky fixes to make it work properly.

# Install quicktile dependencies

sudo apt-get install python python-gtk2 python-xlib python-dbus python-setuptools

# One dependency (python-wnck) that is python 2.7 is no longer available for 18.04,
# so need to temporarily add 17.10 Ubuntu repos and install it

sudo sh -c "echo 'deb http://old-releases.ubuntu.com/ubuntu/ artful main restricted universe multiverse' > /etc/apt/sources.list.d/wnck.list"
sudo sh -c "echo 'deb http://old-releases.ubuntu.com/ubuntu/ artful-updates main restricted universe multiverse' >> /etc/apt/sources.list.d/wnck.list"
sudo sh -c "echo 'deb http://old-releases.ubuntu.com/ubuntu/ artful-backports main restricted universe multiverse' >> /etc/apt/sources.list.d/wnck.list"
sudo sh -c "echo 'deb http://old-releases.ubuntu.com/ubuntu artful-security main restricted universe multiverse' >> /etc/apt/sources.list.d/wnck.list"
sudo apt update
sudo apt install python-wnck

# Clean up some junk so you don't end up with other 17.10 dependencies
sudo rm /etc/apt/sources.list.d/wnck.list
sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
sudo apt-get update 
sudo apt-get upgrade # might as well
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove

# Now install quicktile
sudo pip2 install https://github.com/ssokolow/quicktile/archive/master.zip

# Get rid of error message about libcanberra-gtk something something
sudo apt install libcanberra-gtk-module

# Get rid of error message: Gtk-Message: 11:39:02.795: Failed to load module "pantheon-filechooser-module"
# There are numerous posts about this: Here's one example: https://askubuntu.com/questions/684169/gtk-message-failed-to-load-module-pantheon-filechooser-module
echo "export GTK_MODULES=:gail:atk-bridge" >> ~/.bashrc # removes ":pantheon-filechooser-module" which isn't needed
source ~/.bashrc

# Get rid of error message about pixbuf
sudo apt-get install gnome-themes-standard

# Fix stupid Pantheon/Elementary issue where Elementary apps have huge invisible window borders around them with quicktile
# As a side-benefit, this also fixes the same issue if you want to use i3 (for example, regolith-desktop) as a window
# manager on top of Elementary OS. I personally switch back and forth between i3 and Pantheon with Elementary as the base.

cd /usr/share/themes/elementary/gtk-3.0/
sudo cp gtk-widgets.css gtk-widgets.css.bak
sudo sed -i 's/^decoration {\n.*}


decoration {
    border-radius: 4px 4px 0 0;
    box-shadow:
        0 0 0 1px @decoration_border_color,
        0 14px 28px rgba(0, 0, 0, 0.35),
        0 10px 10px rgba(0, 0, 0, 0.22);
    margin: 12px;
}

/*decoration {
    border-radius: 4px 4px 0 0;
    box-shadow:
        0 0 0 1px @decoration_border_color,
        0 14px 28px rgba(0, 0, 0, 0.35),
        0 10px 10px rgba(0, 0, 0, 0.22);
    margin: 12px;
}*/

decoration {
	box-shadow: none;
	border: none;
	padding: 0;
	margin: 0;
}



# Run quicktile once to generate config
quicktile


