#!/bin/bash

tcpdump -i $(ifconfig | grep tap | cut -d":" -f1) not arp and not rarp and not 'tcp[13] & 4!=0'

#p0f -i tap0 -p -o /data/lab/results/p0f-$(date +%F_%R).log
