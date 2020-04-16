#!/bin/sh

# The following script is used when resetting the server
# Currently every 24 h

~/framework/script/stop.sh

chmod -R 777 ~/server/
rm -rf ~/server/*
cp -Tr ~/server-default/ ~/server/

