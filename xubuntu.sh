#!/bin/bash

# Xubuntu config and installs

# install fonts
sudo apt-get install -y ttf-mscorefonts-installer --quiet
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
# cp -r ~/dotfiles/.fonts/  ~/.fonts/
sudo apt install -y fonts-open-sans fonts-roboto
cd /tmp && wget https://raw.githubusercontent.com/nreith/linux_config/master/googlefonts.sh
sudo bash googlefonts.sh
# install icons

sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install -y papirus-icon-theme libreoffice-style-papirus filezilla-theme-papirus

# stilo themes
sudo apt install -y gtk2-engines-murrine gtk2-engines-pixbuf fonts-roboto ninja-build git meson sassc
git clone https://github.com/lassekongo83/stilo-themes.git
cd stilo-themes
meson build
sudo ninja -C build -y install

# elementary terminal theme
printf '
[Configuration]
ColorForeground=#9494a3a3a5a5
ColorBackground=#25242e2d3232
ColorCursor=#9494a3a3a5a5
ColorPalette=rgb(7,54,66);rgb(220,50,47);rgb(133,153,0);rgb(181,137,0);rgb(38,139,210);rgb(236,0,72);rgb(42,161,152);rgb(148,163,165);rgb(88,110,117);rgb(203,75,22);rgb(133,153,0);rgb(181,137,0);rgb(38,139,210);rgb(211,54,130);rgb(42,161,152);rgb(238,238,238)
FontName=Roboto Mono 9
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBellUrgent=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscMouseWheelZoom=TRUE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscMiddleClickOpensUri=FALSE
MiscCopyOnSelect=FALSE
MiscShowRelaunchDialog=TRUE
MiscRewrapOnResize=TRUE
MiscUseShiftArrowsToScroll=FALSE
MiscSlimTabs=FALSE
MiscNewTabAdjacent=FALSE
ColorCursorUseDefault=FALSE
BackgroundMode=TERMINAL_BACKGROUND_TRANSPARENT
BackgroundDarkness=0.900000' > ~/.config/xfce4/terminal/terminalrc

# app and ds installs
cd /tmp && https://raw.githubusercontent.com/nreith/linux_config/master/installs.sh
source installs.sh

