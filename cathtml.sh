#!/bin/bash
#cat index.html | grep "href" | cut -d"/" -f3| grep "cisco\.com" | cut -d'"' -f1 | sort -u > cisco.txt
# or
grep -o '[A-Za-z0-9_\.-]*\.*cisco.com' index.html | sort -u > cisco.txt
