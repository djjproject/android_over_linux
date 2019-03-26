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

# alert message
echo "$(tput setaf 1)Android over Linux Debian 9 Stretch update Finished...$(tput sgr 0)"
echo "$(tput setaf 1)You should reboot Device. may enter "reboot" on terminal.$(tput sgr 0)"




