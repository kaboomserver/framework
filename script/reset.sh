#!/bin/sh

# The following script is used when resetting the server
# Currently every 24 h

pkill -9 init.sh
pkill -9 schematics.sh
pkill -9 server.sh
pkill -9 java

# Sync changes with the GitHub repository
cd ~/framework
git fetch origin --depth 1
git reset --hard origin/master
git reflog expire --expire=all --all
git gc --prune=all

cd ~/server-default
git fetch origin --depth 1
git reset --hard origin/master
git reflog expire --expire=all --all
git gc --prune=all

chmod -R 777 ~/server/
rm -rf ~/server/*
cp -Tr ~/server-default/ ~/server/

