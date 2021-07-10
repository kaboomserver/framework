#!/bin/sh

# This script is used as a reference to generate a stripped-down JRE for the server

rm -rf java/
wget https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_linux_hotspot_16.0.1_9.tar.gz
tar -zxvf OpenJDK*
rm OpenJDK*
mv jdk* jdk/
jdk/bin/jlink --no-header-files --no-man-pages --compress=2 --strip-debug \
	--exclude-files=**java_*.properties,**jrunscript,**keytool,**legal/** \
	--add-modules java.desktop,java.logging,java.management,java.naming,java.net.http,java.scripting,java.sql,jdk.crypto.ec,jdk.unsupported,jdk.zipfs \
	--output java
rm -rf jdk/
