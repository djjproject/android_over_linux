#!/bin/bash

MOUNT_DIR=/mnt/by-uuid
LOG=/var/log/uuidmount.log
touch $LOG

# forever loop
while true; do
	# get partition count
	CUR_PARTCOUNT=$(cat /proc/partitions | wc -l)

	# if differ, umount all folders and remove.
	# re-run uuid mount script.
	if [ "$TEMP_COUNT" != "$CUR_PARTCOUNT" ]; then
		echo "[$(date "+%Y-%m-%d %H:%M:%S")] UPDATE /mnt/by-uuid..." >> $LOG
		TEMP_COUNT=$CUR_PARTCOUNT

		for MOUNTS in $MOUNT_DIR/*; do
			umount -l $MOUNTS > /dev/null 2&>1
		done

		rm -rf $MOUNT_DIR/*

		lsblk -o KNAME -r | grep 'sd[a-z][0-9]' > /dev/uuidmount
		cat /dev/uuidmount | while read block; do
			uuid=`blkid -s UUID -o value '/dev/'$block`
			mkdir -p '/mnt/by-uuid/'$uuid
			while [ -z '/mnt/media_rw/'$block ]; do
				mount -o bind '/mnt/media_rw/'$block '/mnt/by-uuid/'$uuid
				echo "[$(date "+%Y-%m-%d %H:%M:%S")] '/mnt/by-uuid/'$uuid" >> $LOG	
			done
		done

		lsblk -o KNAME | grep 'mmcblk1p' > /dev/uuidmount
		cat /dev/uuidmount | while read block; do
			echo "BLOCK is $block"
			mkdir -p '/mnt/by-uuid/'$block
			mount -o bind '/mnt/media_rw/'$block '/mnt/by-uuid/'$block
		done
		echo "[$(date "+%Y-%m-%d %H:%M:%S")] UPDATE finished..." >> $LOG
	fi

	sleep 1
done
