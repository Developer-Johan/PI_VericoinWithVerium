#!/bin/bash

cd ~
clear

#Install git
printf "\e[32mInstall git\e[0m\n"
sudo apt -y install git

#Clone from git
printf "\e[32mClone from git\e[0m\n"

if 
	cd ~/git/pi_vericoinwithverium/; 
	then 
		git reset;
		git reset --hard
		git pull; 
	else 
		git clone -v https://github.com/Developer-Johan/PI_VericoinWithVerium.git ~/git/pi_vericoinwithverium/
fi

#------------------------------------------------------------------#

#Give all scripts righs
sudo find ~/git/pi_vericoinwithverium/ -name '*.sh' -print0 | xargs -0 sudo chmod +x

#run scripts for pi_vericoinwithverium
cd ~/git/pi_vericoinwithverium/

#------------------------------------------------------------------#

./startupscript.sh