#!/bin/bash

printf "Startup\n";

/root/scripts/vericoind_startwithoutstake.sh
#./vericoind_startwithstake.sh

printf "Finished starting\n";

#sleep script
sleep infinity

printf "Shutdown\n";