#!/bin/bash

MOUNT_DIR=/mnt/by-uuid
LOG=/var/log/uuidmount.log

touch $LOG
mkdir $MOUNT_DIR > /dev/null 2>&1
TEMP_COUNT=1

# forever loop
while true; do
	# get partition count
	CUR_PARTCOUNT=$(cat /proc/partitions | wc -l)

	# if differ, umount all folders and remove.
	# re-run uuid mount script.
	if [ "$TEMP_COUNT" != "$CUR_PARTCOUNT" ]; then
		echo "[$(date "+%Y-%m-%d %H:%M:%S")] UPDATE /mnt/by-uuid..." >> $LOG
		TEMP_COUNT=$CUR_PARTCOUNT
		
		# ensure path unmounted.
		for MOUNTS in $MOUNT_DIR/*; do
			umount -l $MOUNTS > /dev/null 2>&1
			umount -l $MOUNTS > /dev/null 2>&1
			umount -l $MOUNTS > /dev/null 2>&1
		done
		
		# cleanup by-uuid folder.
		rm -rf $MOUNT_DIR/*
		
		# get sdxx name.
		lsblk -o KNAME -r | grep 'sd[a-z][0-9]' > /dev/uuidmount
		# read sdxx name, save to block.
		cat /dev/uuidmount | while read block; do
			# find uuid value based on $block.
			uuid=`blkid -s UUID -o value '/dev/block/'$block`
			mkdir -p /mnt/by-uuid/$uuid

			# wait for android vold manager mount disk.
			while [ ! -d /mnt/media_rw/$block ]; do
				sleep 1
			done

			# vold mount path <---> by-uuid path binding.
			mount -o bind /mnt/media_rw/$block /mnt/by-uuid/$uuid
			echo "[$(date "+%Y-%m-%d %H:%M:%S")] /dev/block/$block --> /mnt/by-uuid/$uuid" >> $LOG	
		done

		echo "[$(date "+%Y-%m-%d %H:%M:%S")] UPDATE finished..." >> $LOG
	fi

	sleep 1
done
