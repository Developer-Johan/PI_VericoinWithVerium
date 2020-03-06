#!/bin/bash

cd docker/
sudo docker build ./docker/ -t veriumminer:latest --no-cache
cd ..