apt-get autoclean
apt-get clean
apt-get autoremove
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
if ! [ -x "$(command -v deborphan)" ]; then
  echo 'deborphan is not installed.' >&2
  apt-get install deborphan
else
  apt-get remove --purge $(deborphan)
fi
if ! [ -x "$(command -v localepurge)" ]; then
  echo 'localpurge is not installed.' >&2
  apt-get install localepurge
else
  localepurge
fi
if ! [ -x "$(command -v ncdu)" ]; then
  echo 'ncdu is not installed.' >&2
  apt-get install ncdu
else
  ncdu
fi
