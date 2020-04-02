#!/bin/bash

# Give Full Sudo Perms
#echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

echo "Sudo Credentials required to install rxvt"

sudo apt -y install rxvt-unicode

git clone https://github.com/karthick-kk/dotfiles.git /tmp/kkdots

mkdir -p $HOME/.urxvt/ext/
cp -r /tmp/kkdots/X/.urxvt/ext/* $HOME/.urxvt/ext/
cp /tmp/kkdots/X/.Xresources $HOME/

xrdb -load $HOME/.Xresources

echo "Installation Completed:"
echo "Start your terminal: urxvt &"





