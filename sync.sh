#!/usr/bin/env bash

for f in $(ls -d -- .config/*)
do
  rsync -avu --delete $f ~/.config
done
echo "Done syncing config!"
