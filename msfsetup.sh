#!/bin/bash
#
# Metasploit initial setup after fresh install
service postgres status
if [ "$?" -gt "0" ]; then
  echo "Not installed".
else
  echo "Intalled"
fi
