#!/usr/bin/env bash


cp -av home/. ~/ 
echo "Done syncing home dotfiles!"

for folder in $(ls -d -- .config/*)
do
  rsync -avu --delete $folder ~/.config
done
echo "Done syncing config!"
