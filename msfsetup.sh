#!/bin/bash
#
# Metasploit initial setup after fresh install
mdbname="msfdb"
srvname="postgres"
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
if [ ps auxw | grep $srvname | grep -v grep > /dev/null ]; then
    echo "Postgresql has not been started"
    service postgresql start
    update-rc.d postgresql defaults
else
    echo "Postgresql has been already started"
fi
# Check if the msfdb install installed
if [ psql -lqt | cut -d \| -f 1 | grep -w $mdbname ]; then
    echo "$mdb has already been installed"
else
    echo "Installing $mdb now"
    msfdb init
fi
