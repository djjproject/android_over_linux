#!/bin/bash

# update source list
cat <<EOF > /etc/apt/sources.list
# debian stretch repo
deb http://ftp.kr.debian.org/debian/ stretch main contrib non-free
deb-src http://ftp.kr.debian.org/debian/ stretch main contrib non-free

# debian stretch-backports repo
deb http://ftp.kr.debian.org/debian stretch-backports main contrib non-free
deb-src http://ftp.kr.debian.org/debian stretch-backports main contrib non-free

# plexmediaserver repo
deb https://dev2day.de/pms/ stretch main

EOF

# apt update and upgrade, upgrade
apt-get update
apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# reboot patch
rm /etc/rc0.d/K02urandom
rm /etc/rc0.d/K06hwclock.sh
rm /etc/rc0.d/K06umountnfs.sh
rm /etc/rc0.d/K08umountfs
rm /etc/rc0.d/K09umountroot
rm /etc/rc0.d/K04sendsigs
rm /etc/rc0.d/K10halt

# welcome message patch
sed -i -e "s/8 jessie/9 stretch/g" /etc/motd

# upmpdcli patch
wget http://u5pvr.djjproject.com/libupnpp5_armhf.deb
wget http://u5pvr.djjproject.com/upmpdcli_1.4.0_armhf.deb
apt-get install --yes ./libupnpp5_armhf.deb
apt-get install --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ./upmpdcli_1.4.0_armhf.deb
rm libupnpp5_armhf.deb
rm upmpdcli_1.4.0_armhf.deb

# package autoremove
apt-get autoremove --yes
apt-get autoclean
apt-get clean

rm stretch-upgrade.sh

# alert message
echo "$(tput setaf 1)Android over Linux Debian 9 Stretch update Finished...$(tput sgr 0)"
echo "$(tput setaf 1)You should reboot Device. may enter "reboot" on terminal.$(tput sgr 0)"




