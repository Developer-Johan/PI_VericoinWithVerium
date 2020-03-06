#!/bin/bash

#Update and upgrade
printf "\e[32mStarting update + upgrade\e[0m\n"
printf "\e[33mCurrent path is: '`pwd`'\e[0m\n"
sudo apt -y update
sudo apt -y upgrade