#!/bin/bash
#
# Metasploit initial setup after fresh install
service postgres status
if [ "$?" -gt "0" ]; then
  service postgresql start
else
  msfdb init
fi
