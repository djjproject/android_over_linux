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
DEBIAN_FRONTEND=noninteractive apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND=noninteractive apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

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

# version command patch
sed -i -e "s/GNU/Linux Debian 8 jessie/GNU/Linux Debian 9 stretch/g" /usr/bin/version

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

# uuid mount patch
cat <<'EOF' > /etc/init.d/aolconfig
#!/bin/sh
### BEGIN INIT INFO
# Provides:          aolconfig
# Required-Start:    hostname $local_fs
# Required-Stop:     
# Default-Start:     1 2 3 4 5
# Default-Stop:      
# Short-Description: androidoverlinux config script
# Description:       config by djjproject
### END INIT INFO
do_start() {
    # AOL INIT SCRIPT
    rm /var/lib/plexmediaserver/Plex\ Media\ Server/plexmediaserver.pid
    mkdir /dev/net
    ln -s /dev/tun /dev/net/tun
    ln -s /dev/block/* /dev
    # disk uuid mount
    lsblk -o KNAME -r | grep 'sd[a-z][0-9]' > /dev/uuidmount
    cat /dev/uuidmount | while read block
    do
	echo "BLOCK is $block"
	uuid=`blkid -s UUID -o value '/dev/'$block`
	mkdir -p '/mnt/by-uuid/'$uuid
	mount -o bind '/mnt/media_rw/'$block '/mnt/by-uuid/'$uuid
    done
    lsblk -o KNAME | grep 'mmcblk1p' > /dev/uuidmount
    cat /dev/uuidmount | while read block
    do
        echo "BLOCK is $block"
	mkdir -p '/mnt/by-uuid/'$block
        mount -o bind '/mnt/media_rw/'$block '/mnt/by-uuid/'$block
    done
}
case "$1" in
  start)
    do_start
  ;;
  stop)
  ;;
  restart)
  ;;
  *)
    echo "Usage: "$1" {start|stop|restart}"
    exit 1
  ;;
esac
exit 0
EOF

# alert message
echo "$(tput setaf 1)Android over Linux Debian 9 Stretch update Finished...$(tput sgr 0)"
echo "$(tput setaf 1)You should reboot Device. may enter "reboot" on terminal.$(tput sgr 0)"




