#!/bin/bash

# Yellow Terminal message
function output { 
	YELLOW='\033[0;33m'
	NC='\033[0m'
	echo -e "\n${YELLOW}$1${NC}"
}

ANDROID_SAMBA_DIR=/data/data/com.explorer/samba/lib

output "fix android smbd service.\nreflink : https://cafe.naver.com/mk802/35619"

output "make dfree script..."
touch $ANDROID_SAMBA_DIR/dfree
cat << 'EOF' > $ANDROID_SAMBA_DIR/dfree
#!/system/bin/sh
echo "-1 50%"
EOF

output "fix permissions..."
chown aid_system:aid_system $ANDROID_SAMBA_DIR/dfree
chmod 6755 $ANDROID_SAMBA_DIR/dfree

output "add dfree command smb.conf..."
if [[ "$(cat $ANDROID_SAMBA_DIR/smb.conf | grep "dfree command")" != *"dfree command"* ]]; then
	sed -i -e "/max protocol = SMB2/a dfree command = $ANDROID_SAMBA_DIR/dfree" $ANDROID_SAMBA_DIR/smb.conf
else
	output "already smb.conf have dfree command..."
fi

output "android smbfix finished...\nyou must reboot device."
read -p "Do you want reboot? enter y. : " reboot
if [ "$reboot" = "y" ]; then
	sync
	/sbin/reboot
fi




