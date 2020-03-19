#!/bin/bash

sudo docker rm veriumminer -f
sudo docker run -d --restart=always --mount source=veriumminer_root_home,target=/root --cpu-shares 2 --name veriumminer veriumminer /root/scripts/startup.sh