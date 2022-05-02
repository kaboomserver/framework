#!/bin/sh

# This script is used as a reference to generate a stripped-down JRE for the server

rm -rf java/
curl -L https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_linux-x64_bin.tar.gz > openjdk.tar.gz
tar -zxvf openjdk.tar.gz
rm openjdk.tar.gz
mv jdk* jdk/
jdk/bin/jlink --no-header-files --no-man-pages --compress=2 --strip-debug \
	--exclude-files=**java_*.properties,**jrunscript,**keytool,**legal/** \
	--add-modules java.desktop,java.instrument,java.logging,java.management,java.naming,java.net.http,java.scripting,java.sql,jdk.crypto.ec,jdk.security.auth,jdk.unsupported,jdk.zipfs \
	--output java
rm -rf jdk/
