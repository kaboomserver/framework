#!/bin/sh

# The following script is used when resetting the server
# Currently every 24 h

pkill -9 init.sh
pkill -9 schematics.sh
pkill -9 server.sh
pkill -9 java

# Sync changes with the GitHub repository
cd ~/framework
git pull

cd ~/server-default
git pull

chmod -R 777 ~/server/
rm -rf ~/server/*
cp -Tr ~/server-default/ ~/server/

