#!/bin/bash
#
# Metasploit initial setup after fresh install
#
# Check if certain packages are installed
arrayPKG=( postgresql )
for pkgname in "${arrayPKG[@]}"
do
    if [ $(dpkg-query -W -f='${Status}' $pkgname 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "apt-get install $pkgname"
    else
        echo "$pkgname is installed"
    fi
done
# Check if postgresql is started
#if [ $(ps -ef | grep -v grep | grep postgres | wc -l) > 0 ]; then
if [ $(service postgres status | grep -c "inactive") ]; then
    echo "Postgresql has not been started"
    service postgresql start
    update-rc.d postgresql defaults
else
    echo "Postgresql has been already started"
fi
# Check if the msfdb install installed
if [ $(sudo -u postgres -H -- psql -l | grep msf | wc -l) > 0 ]; then
    echo "msfdb has already been installed"
else
    echo "Setting up msfdb now"
    msfdb init
fi
