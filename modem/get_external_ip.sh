#!/bin/bash

external_ip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')

echo ${external_ip}

nslookup ${external_ip}

