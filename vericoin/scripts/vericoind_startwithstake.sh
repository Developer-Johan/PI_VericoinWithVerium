#!/bin/bash
clear

printf "Start vericoin deamon\n";

vericoind -daemon -staking -conf=~/.vericoin/vericoin.conf -wallet=wallet.dat -walletpassphrase=whahanotgonnasharethat &

printf "Finish vericoin deamon\n";

sleep 180

/root/scripts/vericoind_stake_start