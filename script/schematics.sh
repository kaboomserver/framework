#!/bin/sh

# Schematics are saved in a separate git repository.
# Only non-existing files are added to the repository.

set -x

folder=~/server/plugins/FastAsyncWorldEdit/schematics/
hostname=github.com

ssh-keygen -R $hostname
ssh-keyscan -H $hostname >> ~/.ssh/known_hosts

while true; do
	if [ ! -d "$folder" ]; then
		git clone --depth 1 git@$hostname:kaboomserver/schematics.git $folder
	fi

	cd $folder

	if [ "$(git add $(git ls-files -o) -v)" ]; then
		git -c user.name='kaboom' -c user.email='kaboom.pw' commit -m "Add new schematics"
		git push
	fi
	sleep 1
done
