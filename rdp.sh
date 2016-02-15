#!/bin/bash

echo "What server to dyou want to connect to?"
read $rdpsrvr

echo "Who should I login as"
read $user

echo "What password should I use?"
read $password

rdesktop -u $user -p $password $rdpsrvr
