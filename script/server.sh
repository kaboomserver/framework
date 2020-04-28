#!/bin/sh

# The alive checker and Minecraft server is started at the same time. For performance reasons, the
# OpenJ9 JVM is used instead of Java's default Hotspot JVM.

PATH="$HOME/framework/vendor/java/bin/:$PATH"

dtach -n alivecheck $HOME/framework/script/alivecheck.sh

# Make sure we're in the server folder, located in the home directory
cd ~/server/

# Make certain files and folders read-only

chmod -R 500 plugins/bStats/
chmod -R 500 plugins/PluginMetrics/
chmod -R 500 plugins/ProtocolLib/
chmod 400 bukkit.yml
chmod 400 commands.yml
chmod 400 eula.txt
chmod 400 permissions.yml
chmod 400 server-icon.png
chmod 400 wepif.yml

while true; do
	java -Xmx1800M -Xss8M -Xtune:virtualized -Xaggressive -Xcompressedrefs -Xdump:heap+java+snap:none -Xdump:tool:events=throw+systhrow,filter=java/lang/OutOfMemoryError,exec="kill -9 %pid" -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc -Xshareclasses -Xshareclasses:noPersistentDiskSpaceCheck -XX:MaxDirectMemorySize=128M -XX:+ClassRelationshipVerifier -XX:+UseContainerSupport -DPaper.IgnoreJavaVersion=true -Dpaper.playerconnection.keepalive=360 -DIReallyKnowWhatIAmDoingISwear -jar server.jar nogui
	sleep 1
done
