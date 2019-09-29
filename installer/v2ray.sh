#!/bin/bash

read -p "vmess port > " vmessport
read -p "shadowsocks port > " shadowport
read -p "shadowsocks password > " shadowpass

wget https://git.io/v2ray.sh -O /tmp/v2ray.sh
chmod a+x /tmp/v2ray.sh

echo -e "1\n3\n$vmessport\nN\nY\n$shadowport\n$shadowpass\n7\n\n" | /tmp/v2ray.sh

rm /tmp/v2ray.sh

echo -e "\n\n [v2ray] installation finished...\n please check above connection information."

exit 0 
