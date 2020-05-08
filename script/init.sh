#!/bin/sh

# This is the core script used when booting up the server
# It asumes that the "framework" folder is located in the home directory

# Run scripts for starting the Minecraft server and schematic
# checker in the background

cd ~/
rm alivecheck kaboom schematics

while true; do
	dtach -n kaboom ~/framework/script/server.sh > /dev/null 2>&1
	dtach -n schematics ~/framework/script/schematics.sh > /dev/null 2>&1
	sleep 5
done &
