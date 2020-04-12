#!/bin/bash

# Yellow Terminal message
function output { 
	YELLOW='\033[0;33m'
	NC='\033[0m'
	echo -e "\n${YELLOW}$1${NC}"
}

output "## tvh parser for u5 series. \n first, you must scan channels on LiveTV app. \n second, LiveTV --> Setup --> Config --> System --> Back Up --> Back Up Channels Data. \n (no usb memory required. just ignore no storage message.)"

output "## get data from backup file..."
CUR_DIR=`pwd`
WORK_DIR=/tmp/tvdata
mkdir -p $WORK_DIR > /dev/null 2>&1

if [ -e /data/tvdata.tar.gz ]; then
	cp /data/tvdata.tar.gz $WORK_DIR
	cd $WORK_DIR
	tar -xf tvdata.tar.gz
else
	output "## can not read tvdata.tar.gz..."
fi

output "## make m3u file..."
echo "#EXTM3U" > $CUR_DIR/tvh_3305.m3u
echo "#EXTM3U" > $CUR_DIR/tvh_3306.m3u

TRANSPORT=$WORK_DIR/tvheadend/dvbtransports

for channel in $TRANSPORT/_dev_dvb*/*
do
	TUNER=$(basename $channel)
	URL=http://localhost:19981/stream/service/$TUNER
	CHNAME=$(cat $channel | jq .channelname)

	FFURL="pipe://ffmpeg -loglevel quiet -i "$URL" -metadata service_provider=u5live -metadata service_name="$CHNAME" -c copy -c:v copy -c:a aac -b:a 128k -f mpegts -tune zerolatency pipe:1"	
	if [ $CHNAME != "null" ]; then
		echo -e "$CHNAME \n$FFURL\n"
		if [[ "${TUNER}" = *"LGDT3305"* ]]; then
			echo "#EXTINF:-1,$CHNAME" >> $CUR_DIR/tvh_3305.m3u
			echo "$FFURL" >> $CUR_DIR/tvh_3305.m3u
		else
			echo "#EXTINF:-1,$CHNAME" >> $CUR_DIR/tvh_3306.m3u
			echo "$FFURL" >> $CUR_DIR/tvh_3306.m3u

		fi
	fi
done

output "## make m3u finished..."
#rm -rf $WORK_DIR
