#!/bin/bash

if [ ! -d "/var/lib/docker/volumes/" ] 
then
	printf "\e[32mSetting rights right\e[0m\n"
	sudo chown $USER /var/lib/docker/ -R
fi

if [ ! -d "/var/lib/docker/volumes/verium_root_home/_data/" ] 
then
	printf "\e[32mCreating docker volume for verium\e[0m\n"
	mkdir -p /var/lib/docker/volumes/verium_root_home/_data/.verium/

	if [ ! -d "/var/lib/docker/volumes/verium_root_home/_data/.verium/" ] 
	then
		printf "\e[32mSetting rights right\e[0m\n"
		sudo chown $USER /var/lib/docker/volume/verium_root_home/_data/ -R
	fi

	printf "\e[32mGetting verium.conf\e[0m\n"
	cp data/verium.conf /var/lib/docker/volume/verium_root_home/_data/.verium/

	printf "Creating scripts directory\n"
	mkdir /var/lib/docker/volumes/verium_root_home/_data/scripts/

	printf "Copy scripts\n"
	for filename in scripts/*; do
		printf "Copy to scripts folder: $filename\n"
		cp $filename /var/lib/docker/volumes/verium_root_home/_data/scripts/
		sudo chmod +x $filename 
	done
fi
