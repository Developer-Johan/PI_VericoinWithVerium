#!/bin/bash

cd ~
clear

while true; do
  read -p "Do you wish to install/update the needed software? " yn
    case $yn in
        [Yy]* ) softwareinstall=true; break;;
        [Nn]* ) softwareinstall=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
  read -p "Do you wish to install docker? " yn
    case $yn in
        [Yy]* ) dockerinstall=true; break;;
        [Nn]* ) dockerinstall=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
  read -p "Do you wish to install/update veriumminer? " yn
    case $yn in
        [Yy]* ) veriumminerinstall=true; break;;
        [Nn]* ) veriumminerinstall=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

#------------------------------------------------------------------#

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

#Software install
if [ $softwareinstall == true ]
then
    #Run update
    ./install/update.sh

    #Run installeprogramms
    ./install/installeprogramms.sh
fi

#Docker install
if [ $dockerinstall == true ]
then
    #Runinstalldocker
    ./install/installdocker.sh
fi

#veriumminer
if [ $veriumminerinstall == true ]
then
    cd veriumminer
    ./buildnewdockerimage.sh
    ./runcontainer.sh
    cd ..
fi