#!/bin/sh
set -e
# This script is used to generate a stripped-down JRE for the server

JDK_VERSION="21"
JDK_OS="linux"
JDK_ARCHITECTURE="x64"

fetch() {
	curl -fL \
		--proto =http,https \
		"$@"
}

download_extract() {
	tar_path="$(mktemp --suffix=.tar.gz)"

	exitcode=0
	fetch -# "$1" -o "$tar_path" || exitcode=$?
	if [ $exitcode != 0 ]; then
		rm -f "$tar_path" 2>/dev/null
		return $exitcode
	fi

	mkdir -p "$2"
	tar \
		--strip-components=1 \
		-xf "$tar_path" \
		-C "$2" || exitcode=$?
	rm -f "$tar_path" 2>/dev/null

	return $exitcode
}

JDK_URL="$(fetch -so- "https://api.adoptium.net/v3/assets/latest/$JDK_VERSION/hotspot" | \
	jq --raw-output --exit-status \
		--arg architecture "$JDK_ARCHITECTURE" --arg os "$JDK_OS" \
		'.[].binary | select(.image_type == "jdk" and .architecture == $architecture and .os == $os) | .package.link')"

[ -d jdk ] && rm -rf jdk
echo "Downloading Adoptium $JDK_VERSION..."
download_extract "$JDK_URL" jdk/

[ -d java ] && rm -rf java
echo "Building custom JRE..."
jdk/bin/jlink --no-header-files --no-man-pages --strip-debug \
	--exclude-files=**java_*.properties,**jrunscript,**keytool,**legal/** \
	--add-modules java.compiler,java.desktop,java.instrument,java.logging,java.management,java.naming,java.net.http,java.scripting,java.sql,jdk.crypto.ec,jdk.naming.dns,jdk.security.auth,jdk.unsupported,jdk.zipfs \
	--output java
rm -rf jdk

echo "Generating shared classes..."
java/bin/java -Xshare:dump

