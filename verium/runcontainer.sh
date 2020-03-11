#!/bin/bash

docker rm verium -f
sudo docker run -d --restart=always --mount source=verium_root_home,target=/root --cpu-shares 512 --name verium verium /root/scripts/startup.sh