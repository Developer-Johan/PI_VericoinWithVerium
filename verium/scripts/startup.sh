#!/bin/bash

printf "Startup\n";

veriumd -daemon -conf=~/.verium/verium.conf

printf "Finished starting\n";

#sleep script
sleep infinity

printf "Shutdown\n";
