#!/bin/bash

LAN_NET="192.168.1.0/24"
ISP1_GW="192.168.1.254"
ISP2_GW="192.168.8.254"

iptables -t mangle -A POSTROUTING -d \! $LAN_NET \
                   -p tcp -m tcp --sport 22 \
                   -j ROUTE --gw $ISP2_GW

