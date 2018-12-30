#!/bin/bash

 set -x

# USB phone rndis_host interface
IF_1=enp0s20u2
IP_1=$(ip addr show ${IF_1} | grep -Po 'inet \K[\d.]+')
GW_1=192.168.1.1

#NET_1="192.168.42.0/24"
#GW_1=$(ip r | grep "via 192.168.42" | awk '{print $3}')

# local eth interface
IF_2=br_switch
IP_2=$(ip addr show ${IF_2} | grep -Po 'inet \K[\d.]+')
GW_2=192.168.42.129

#NET_2="192.168.1.0/24"
#GW_2=$(ip r | grep "via 192.168.1" | awk '{print $3}')


echo ${IF_1} ${IP_1} ${NET_1} ${GW_1}
echo ${IF_2} ${IP_2} ${NET_2} ${GW_2}

function clean()
{
	# cleaning routes
	ip route flush cache
	ip route del default via ${GW_1} dev ${IF_1}
	ip route del default via ${GW_2} dev ${IF_2}
	ip route del default nexthop via ${GW_1} nexthop via ${GW_2}
}


if [ "$1" == "multiwan" ] ;
then
	clean

	# forcing DNS
	echo "nameserver 1.1.1.1" > /etc/resolv.conf

	# avoid weird packet with wrong src ip addr
	iptables -t nat -A POSTROUTING -o ${IF_1} -j SNAT --to-source ${IP_1}
	iptables -t nat -A POSTROUTING -o ${IF_2} -j SNAT --to-source ${IP_2}

	ip route add default scope global	\
		nexthop via $GW_1 weight 1	\
		nexthop via $GW_2 weight 1

	# debug
	ip route


elif [ "$1" == "boxwan" ] ;
then
	clean
	ip route add default via $GW_2 dev ${IF_2}

elif [ "$1" == "phonewan" ] ;
then
	clean
	ip route add default via $GW_1 dev ${IF_1}
fi

