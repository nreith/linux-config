#!/bin/bash

# Setup keyboard window tiling for Elementary OS

# Installs quicktile (https://github.com/ssokolow/quicktile) 
# for Elementary OS 5.1 Hera (https://elementary.io/)
# based on Ubuntu 18.04 LTS (http://releases.ubuntu.com/18.04/)
# with required hacky fixes to make it work properly.

# Install quicktile dependencies

sudo apt-get install python python-gtk2 python-xlib python-dbus python-setuptools

# On dependency that is python 2.7 is no longer available for 18.04, so need to temporarily add 17.10 Ubuntu repos
# and install it


python-wnck
