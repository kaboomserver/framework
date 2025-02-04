#!/bin/sh

# The alive checker and Minecraft server is started at the same time

PATH="$HOME/framework/vendor/java/bin/:$PATH"

# Make sure we're in the server folder, located in the home directory
cd ~/server/

while true; do
	# Check if the server is stuck in a crash loop, and reset worlds if this is the case
	# The alive checker resets server_stops.log if the server runs long enough

	stop_log_file=server_stops.log

	if [ -f "$stop_log_file" ] && [ "$(wc -l < $stop_log_file)" -gt 3 ]; then
		rm -rf worlds/ plugins/FastAsyncWorldEdit/clipboard/ plugins/FastAsyncWorldEdit/history/
		rm "$stop_log_file"
	fi

	# Make certain files and folders read-only

	mkdir debug/ dumps/ plugins/update/
	chmod -R 500 debug/ dumps/ plugins/bStats/ plugins/PluginMetrics/ plugins/update/
	chmod 500 plugins/
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
		-Xms3400M -Xmx3400M \
		\
		-Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true \
		-XX:+UseG1GC \
		-XX:+ParallelRefProcEnabled \
		-XX:MaxGCPauseMillis=200 \
		-XX:+UnlockExperimentalVMOptions \
		-XX:+DisableExplicitGC \
		-XX:+AlwaysPreTouch \
		-XX:G1HeapWastePercent=5 \
		-XX:G1MixedGCCountTarget=4 \
		-XX:G1MixedGCLiveThresholdPercent=90 \
		-XX:G1RSetUpdatingPauseTimePercent=5 \
		-XX:SurvivorRatio=32 \
		-XX:+PerfDisableSharedMem \
		-XX:MaxTenuringThreshold=1 \
		-XX:G1NewSizePercent=30 \
		-XX:G1MaxNewSizePercent=40 \
		-XX:G1HeapRegionSize=8M \
		-XX:G1ReservePercent=20 \
		-XX:InitiatingHeapOccupancyPercent=15 \
		-Xss8M \
		-XX:MaxDirectMemorySize=512M \
		\
		-XX:-UsePerfData \
		-Dpaper.playerconnection.keepalive=60 \
		-DIReallyKnowWhatIAmDoingISwear \
		\
		-jar server.jar nogui

	# Stop alive checker (will be started again on the next run)

	pkill -9 alivecheck.sh
	echo $(date) >> "$stop_log_file"

	# Ensure we don't abuse the CPU in case of failure
	sleep 1
done
