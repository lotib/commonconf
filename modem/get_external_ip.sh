#!/bin/bash

external_ip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')

echo ${external_ip}

if [ "$1" == "all" ] ;
then
	nslookup ${external_ip}
	whois ${external_ip}
fi



