#!/bin/bash

sudo docker rm vericoin -f
sudo docker run -d --restart=always --mount source=vericoin_root_home,target=/root -p 58684:58684 --name vericoin vericoin /root/scripts/startup.sh