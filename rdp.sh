#!/bin/bash

echo "What server to dyou want to connect to?"
read $rdpsrvr

echo "What password should I use?"
read $password

rdesktop -u offsec -p $password $rdpsrvr
