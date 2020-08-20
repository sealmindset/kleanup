#!/bin/bash
distro=$(lsb_release -si)
version=$(lsb_release -d | cut -d" " -f3)
header=$(uname -r | cut -d"-" -f1)
apt-get autoclean
apt-get clean
apt-get autoremove
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
if [ $version = "Rolling" ]; then
  if [ $header = "4.3.0"]; then
    echo 'Header $header is already installed.'
  else
    apt-get install linux-headers-4.3.0-kali-all
  fi
else
  echo 'Version: $version'
fi
if [ $(type deborphan | wc -l) -lt 1 ]; then
  echo 'deborphan is not installed.'
  apt-get install deborphan
else
  apt-get remove --purge $(deborphan)
fi
if [ $(type git | wc -l) -lt 1 ]; then
  echo 'git is not installed.'
  apt-get install git
fi
if [ $(type localepurge | wc -l) -lt 1 ]; then
  echo 'localpurge is not installed.'
  apt-get install localepurge
else
  localepurge
fi
if [ $distro = "Kali" ]; then
  if [ $(type go | wc -l) -lt 1 ]; then
    echo 'GOTTY is not installed.'
    apt-get install golang
  fi
fi
if [ $(type ncdu | wc -l) -lt 1 ]; then
  echo 'ncdu is not installed.'
  apt-get install ncdu
else
  ncdu /
fi
