#!/bin/bash

[ ${#} != 1 ] && echo "usage: $0 file.ovpn" && exit

openvpn --script-security 2 --config ${1}


