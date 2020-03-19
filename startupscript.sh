#!/bin/bash

echo "";
echo "What do you want to install? Pleas answer the questions below.";

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

while true; do
  read -p "Do you wish to install/update vericoin? " yn
    case $yn in
        [Yy]* ) vericoininstall=true; break;;
        [Nn]* ) vericoininstall=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
  read -p "Do you wish to install/update verium? " yn
    case $yn in
        [Yy]* ) veriuminstall=true; break;;
        [Nn]* ) veriuminstall=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

#------------------------------------------------------------------#

#Software install
if [ $softwareinstall = true ]
then
    #Run update
    ./install/update.sh

    #Run installeprogramms
    ./install/installeprogramms.sh
fi

#Docker install
if [ $dockerinstall = true ]
then
    #Runinstalldocker
    install/installdocker.sh
fi

#veriumminer
if [ $veriumminerinstall = true ]
then
    cd veriumminer
    ./buildnewdockerimage.sh
    ./setuproothome.sh
    ./runcontainer.sh
    cd ..
fi

#vericoin
if [ $vericoininstall = true ]
then
    cd vericoin
    ./buildnewdockerimage.sh
    ./setuproothome.sh
    ./runcontainer.sh
    cd ..
fi

#verium
if [ $veriuminstall = true ]
then
    cd verium
    ./buildnewdockerimage.sh
    ./setuproothome.sh
    ./runcontainer.sh
    cd ..
fi

