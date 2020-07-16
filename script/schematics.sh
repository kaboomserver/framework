#!/bin/sh

# Schematics are saved in a separate git repository.
# Only non-existing files are added to the repository.

set -x

ssh-keyscan github.com >> .ssh/known_hosts
folder=~/server/plugins/FastAsyncWorldEdit/schematics/

while true; do
	if [ ! -d "$folder" ]; then
		git clone --depth 1 git@github.com:kaboomserver/schematics.git $folder
	fi

    cd $folder

	if [ "$(git add $(git ls-files -o) -v)" ]; then
		git -c user.name='kaboom' -c user.email='kaboom.pw' commit -m "Add new schematics"
		git push
	fi
	sleep 1
done
