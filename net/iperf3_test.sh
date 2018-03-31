#!/bin/bash
#
# select adress from this page
# https://iperf.fr/iperf-servers.php
#
#

for i in {0..10}; do
    iperf3 -c bouygues.iperf.fr && break
done



