#!/bin/bash

for i in {3000..3100} ;
do
    echo -n "p$i.phpnet.org : "
    nslookup p$i.phpnet.org | tail -n 2 | grep Address | sed -e "s/Address: \(.*\)/\1/"
    sleep 0.1
done



