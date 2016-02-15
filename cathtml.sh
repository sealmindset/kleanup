#!/bin/bash

cat index.html | grep "href" | cut -d"/" -f3| grep "cisco\.com" | cut -d'"' -f1 | sort -u
