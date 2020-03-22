#!/bin/bash

function output { 
	YELLOW='\033[0;33m'
	NC='\033[0m'
	echo -e "\n${YELLOW}$1${NC}"
}

output "Install minidlna 1.2.1 with dsd / cover image..."
output "stop minidlna..."
service minidlna stop

output "remove old binary and configuration files..."
rm /usr/local/sbin/minidlnad
rm /usr/sbin/minidlnad
rm /etc/minidlna.conf

output "download minidlnad binary and minidlna.conf..."
wget https://github.com/djjproject/android_over_linux/raw/master/minidlna_1.2.1/minidlnad -O /usr/sbin/minidlnad
wget https://github.com/djjproject/android_over_linux/raw/master/minidlna_1.2.1/minidlna.conf -O /etc/minidlna.conf

output "fix permissions..."
chmod a+x /usr/local/sbin/minidlnad

output "reindexing media files..."
service minidlna start
minidlnad -R
service minidlna restart

output "Installation Finished... reindexing mediafiles takes some time..."
output "minidlna version check..."
minidlnad -V
