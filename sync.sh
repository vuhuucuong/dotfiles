#!/usr/bin/env bash


cp -av home/. ~/ 
echo "--------------------"
echo "Done syncing home dotfiles!"

for folder in $(ls -d -- .config/*)
do
  rsync -avu --delete $folder ~/.config
done
echo "--------------------"
echo "Done syncing config!"
