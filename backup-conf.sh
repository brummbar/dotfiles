#!/bin/bash

source ./bin/utils.sh

dest="~/migration"

# create a folder to hold files
mkdir -p $dest

# copy important folders
cp -r ~/.ssh $dest
cp -r ~/.gnupg $dest

# copy files
cp ~/.zhistory $dest
copy_if_exists ~/.gitconfig.local $dest
