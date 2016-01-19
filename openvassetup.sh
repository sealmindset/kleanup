#!/bin/bash
echo "Please enter a user"
read $user

cd
gpg --gen-key
gpg --export -a "$user" > public.key
gpg --export-secret-key -a "$user" > private.key

wget -c http://www.openvas.org/OpenVAS_TI.asc
gpg --import OpenVAS_TI.asc
gpg --lsign-key 48DB4530

apt-get install rpm
apt-get install nsis
apt-get install alien

openvas-setup
openvas-scapdata-sync
openvas-certdata-sync

openvas-start
echo "Provide a password for the admin account"
read $passwd
openvasmd --user=admin --new-password=$passwd
