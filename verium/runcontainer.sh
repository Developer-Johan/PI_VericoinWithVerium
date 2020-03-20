#!/bin/bash

sudo docker rm verium -f
sudo docker run -d --restart=always --mount source=verium_root_home,target=/root -p 36988:36988 --cpu-shares 512 --name verium verium /root/scripts/startup.sh