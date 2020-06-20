#!/bin/bash

echo "clean logs..."
rm -rf /var/log/*.log
rm -rf /var/log/messages
rm -rf /var/log/apt/*
rm -rf /var/log/mpd/*
rm -rf /var/log/pure-ftpd/*

echo "clean minidlna data..."
service minidlna stop
rm -rf /var/cache/minidlna/*

echo "clean apt cache..."
apt-get autoclean
apt-get clean

echo "clean home directory data..."
rm -rf ~/.android
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.local
rm -rf ~/.nano
rm -rf ~/.ssh
rm -rf ~/.vim
rm -rf ~/adbkey
rm -rf ~/adbkey.pub

echo "clean tmp..."
rm -rf /tmp/*

echo "clean plexmediaserver data..."
service plexmediaserver stop
rm -rf /var/lib/plexmediaserver/*


