#!/bin/sh

# The following script is used when resetting the server
# Currently every 24 h

~/framework/script/stop.sh

rm -rf ~/server/*
cp -Tr ~/server-default/ ~/server/
