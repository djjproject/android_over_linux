#!/bin/bash

# Yellow Terminal message
function output { 
	YELLOW='\033[0;33m'
	NC='\033[0m'
	echo -e "\n${YELLOW}$1${NC}"
}

# make backup android samba service.
output "Make backup for android samba service..."
system-rw
mv /system/bin/smbd /system/bin/smbd_bak
mv /system/bin/nmbd /system/bin/nmbd_bak

# install smbd nmbd.
output "Update repository index and install samba server..."
apt update
apt install samba

# make backup default smb.conf
output "Make backup for default smb.conf file..."
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak

# enable custom smb.conf
output "Enable custom smb.conf configuration file..."
wget https://github.com/djjproject/android_over_linux/raw/master/smbfix/smb.conf -O /etc/samba/smb.conf

# reboot
output "Installation Finished."
output "You must reboot device."
read -p "Do you want reboot? enter y. : " reboot
if [ "$reboot" = "y" ]; then
	sync
	/sbin/reboot
fi



