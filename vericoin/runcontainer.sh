#!/bin/bash

docker rm vericoin -f
sudo docker run -d --restart=always --mount source=vericoin_root_home,target=/root --cpu-shares 2 --name vericoin vericoin /root/scripts/startup.sh