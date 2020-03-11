#!/bin/bash

printf "Start vericoin deamon\n";

vericoind -daemon -conf=~/.vericoin/vericoin.conf &

printf "Finish vericoin deamon\n";