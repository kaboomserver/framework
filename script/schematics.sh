#!/bin/sh

# Schematics are saved in a separate git repository.
# Only non-existing files are added to the repository.

set -x

git clone git@github.com:kaboomserver/schematics.git ~/server/plugins/FastAsyncWorldEdit/schematics/

while true; do
	cd ~/server/plugins/FastAsyncWorldEdit/schematics/
	if [ "$(git add $(git ls-files -o) -v)" ]; then
		git -c user.name='kaboom' -c user.email='kaboom.pw' commit -m "Add new schematics"
		git push
	fi
	sleep 1
done
