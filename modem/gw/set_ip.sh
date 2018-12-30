#!/bin/bash


echo 1 > /proc/sys/net/ipv4/ip_forward

ip a a 192.168.2.20/24 dev enp1s0

IF_1=enp4s0
IP_1=192.168.1.20
GW_1=192.168.1.1

ip a a ${IP_1}/24 dev enp4s0

IF_2=enp0s20u2
IP_2=192.168.42.91
GW_2=192.168.42.129

ip a a ${IP_2}/24 dev enp0s20u2

echo "nameserver 1.1.1.1" > /etc/resolv.conf

# nat 
iptables -t nat -A POSTROUTING -o ${IF_1} -j MASQUERADE
iptables -t nat -A POSTROUTING -o ${IF_2} -j MASQUERADE

# fix source IP address
iptables -t nat -A POSTROUTING -o ${IF_1} -j SNAT --to-source ${IP_1}
iptables -t nat -A POSTROUTING -o ${IF_2} -j SNAT --to-source ${IP_2}

ip route add default scope global	\
	nexthop via $GW_1 weight 1	\
	nexthop via $GW_2 weight 1


## DEBUG

cat /proc/sys/net/ipv4/ip_forward

ip a

ip r

iptables -t nat -L

