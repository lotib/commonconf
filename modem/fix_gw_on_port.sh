#!/bin/bash

LAN_NET="192.168.1.0/24"
ISP1_GW="192.168.1.254"
ISP2_GW="192.168.8.254"
TARGET_PORT=22


iptables -t mangle -A POSTROUTING -d \! $LAN_NET \
                   -p tcp -m tcp --sport $TARGET_PORT \
                   -j ROUTE --gw $ISP2_GW



function mark_implementation()
{
    local TARGET_MARK=42
    local TARGET_TABLE=traffic

    # creates a custom table
    echo "101 $TARGET_TABLE" >> /etc/iproute2/rt_table

    ip route add default table $TARGET_TABLE via $ISP2_GW
    ip rule add fwmark $TARGET_MARK table $TARGET_TABLE

    iptables -t mangle -A OUTPUT -d \! $LAN_NET -p tcp --dport $TARGET_PORT -j MARK --set-mark $TARGET_MARK
}

