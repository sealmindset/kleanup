#!/bin/bash
#
# helper file to install common packages
arrayPKG=( autossh )
for pkgname in "${arrayPKG[@]}"
do
if [ $(dpkg-query -W -f='${Status}' $pkgname 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo "Installing $pkgname"
    apt-get install $pkgname    
else
    echo "$pkgname has already been installed"
fi
done
