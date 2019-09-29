#!/bin/bash

wget https://git.io/v2ray.sh -O /tmp/v2ray.sh
chmod a+x /tmp/v2ray.sh

if [ "x$1" == "xremove" ]; then
	echo -e "2\nY\n" | /tmp/v2ray.sh
	echo -e "\n\n [v2ray] remove finished..."
else
	read -p "vmess port > " vmessport
	read -p "shadowsocks port > " shadowport
	read -p "shadowsocks password > " shadowpass
	echo -e "1\n3\n$vmessport\nN\nY\n$shadowport\n$shadowpass\n7\n\n" | /tmp/v2ray.sh
	echo -e "\n\n [v2ray] installation finished...\n please check above connection information." 

fi

rm /tmp/v2ray.sh

exit 0 
