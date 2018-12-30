#!/bin/bash


if [ $# -lt 1 ]; then

	echo $0 network_interface

	echo "available interface : "
 	ip addr |grep "^[0-9]" | awk '{print $2}' | cut -d':' -f 1	

	exit
fi

itf=$1

bytes=$(cat /sys/class/net/${itf}/statistics/rx_bytes)

echo $(($bytes / 1000000 ))





