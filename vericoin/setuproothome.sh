#!/bin/bash

if [ ! -d "/var/lib/docker/volumes/" ] 
then
	printf "\e[32mSetting rights right\e[0m\n"
	sudo chown $USER /var/lib/docker/ -R
fi

if [ ! -d "/var/lib/docker/volumes/vericoin_root_home/_data/" ] 
then
	printf "\e[32mCreating docker volume for vericoin\e[0m\n"
	mkdir -p /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/

	if [ ! -d "/var/lib/docker/volumes/vericoin_root_home/_data/" ] 
	then
		printf "\e[32mSetting rights right\e[0m\n"
		sudo chown $USER /var/lib/docker/volumes/vericoin_root_home/_data/ -R
	fi

	printf "\e[32mGetting vericoin.conf\e[0m\n"
	cp data/vericoin.conf /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/

	printf "\e[32mGetting peers.dat\e[0m\n"
	cp data/peers.dat /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/

	printf "\e[32mGetting bootstrap.zip\e[0m\n"
	wget https://pivericoin.blob.core.windows.net/pivericoin/bootstrap.zip -O /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/bootstrap.zip
	printf "\e[32mUnzipping bootstrap.zip\e[0m\n"
	unzip -q /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/bootstrap.zip -d /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/

	printf "\e[32mCopy content bootstrap\e[0m\n"
	mv /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/bootstrap/* /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/
	
	printf "\e[32mCopy directory bootstrap\e[0m\n"
	rm /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/bootstrap/ -r
	
	printf "\e[32mCopy file bootstrap.zip\e[0m\n"
	rm /var/lib/docker/volumes/vericoin_root_home/_data/.vericoin/bootstrap.zip 

	printf "Creating scripts directory\n"
	mkdir /var/lib/docker/volumes/vericoin_root_home/_data/scripts/

	printf "Copy scripts\n"
	for filename in scripts/*; do
		printf "Copy to scripts folder: $filename\n"
		cp $filename /var/lib/docker/volumes/vericoin_root_home/_data/scripts/
		sudo chmod +x $filename 
	done
fi
