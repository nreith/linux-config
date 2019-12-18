# linux_config

My Linux install and config files

## Installation

`export MYUSER=nick_reith   # put your username here`

`mkdir ~/repos && cd ~/repos`
`git clone https://github.com/nreith/linux_config.git`
`cd linux_config && sudo chmod +x *.sh`
`./install.sh`








	# Install Grub Customizer Action
	if [[ $opt == *"Install Grub Customizer"* ]]
	then
		printInstallMessage "Installing Grub Customizer"
		addRepository danielrichter2007/grub-customizer
		installPackage grub-customizer
	fi

	# Fix Broken Packages Action
	if [[ $opt == *"Fix Broken Packages"* ]]
	then
		printInstallMessage "Fixing the broken packages"
		sudo apt -y -f install
	fi

	# Clean-Up Junk Action
	if [[ $opt == *"Clean-Up Junk"* ]]
	then
		printInstallMessage "Cleaning-up junk"
		sudo apt -y autoremove
		sudo apt -y autoclean
	fi










