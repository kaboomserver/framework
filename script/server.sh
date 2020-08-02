#!/bin/sh

# The alive checker and Minecraft server is started at the same time. For performance reasons, the
# OpenJ9 JVM is used instead of Java's default Hotspot JVM.

PATH="$HOME/framework/vendor/java/bin/:$PATH"

# Make sure we're in the server folder, located in the home directory
cd ~/server/

while true; do
	# Make certain files and folders read-only

	chmod -R 500 plugins/bStats/
	chmod -R 500 plugins/PluginMetrics/
	chmod -R 500 plugins/ProtocolLib/
	chmod 400 bukkit.yml
	chmod 400 commands.yml
	chmod 400 eula.txt
	chmod 400 paper.yml
	chmod 400 permissions.yml
	chmod 400 server-icon.png
	chmod 400 server.properties
	chmod 400 spigot.yml
	chmod 400 wepif.yml

	# Start alive checker

	dtach -n alivecheck ~/framework/script/alivecheck.sh

	# Start Minecraft server

	java \
		-Xmx1800M \
		-Xss8M \
		-Xtune:virtualized \
		-Xaggressive \
		-Xcompressedrefs \
		-Xdump:heap+java+snap+system:none \
		-Xdump:tool:events=throw+systhrow,filter=java/lang/OutOfMemoryError,exec="kill -9 %pid" \
		-Xgc:concurrentScavenge \
		-Xgc:dnssExpectedTimeRatioMaximum=3 \
		-Xgc:scvNoAdaptiveTenure \
		-Xdisableexplicitgc \
		-Xshareclasses \
		-Xshareclasses:noPersistentDiskSpaceCheck \
		-XX:MaxDirectMemorySize=128M \
		-XX:+ClassRelationshipVerifier \
		-XX:+GlobalLockReservation \
		-XX:+UseContainerSupport \
		-DPaper.IgnoreJavaVersion=true \
		-Dpaper.playerconnection.keepalive=360 \
		-DIReallyKnowWhatIAmDoingISwear \
		-jar server.jar nogui

	# Stop alive checker (will be started again on the next run)

	pkill -9 alivecheck.sh

	# Ensure we don't abuse the CPU in case of failure
	sleep 1
done
