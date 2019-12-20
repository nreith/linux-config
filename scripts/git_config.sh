#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install git

git config --global user.name "Nick Reith"
git config --global user.email "nreith@gmail.com"
git config --global core.editor subl
