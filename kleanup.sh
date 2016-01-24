apt-get autoclean
apt-get clean
apt-get autoremove
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
if [ $(type deborphan | wc -l) < 1 ]; then
  echo 'deborphan is not installed.' >&2
  apt-get install deborphan
else
  apt-get remove --purge $(deborphan)
fi
if [ $(type git | wc -l) < 1 ]; then
  echo 'git is not installed.' >&2
  apt-get install git
fi
if [ $(type localepurge | wc -l) < 1 ]; then
  echo 'localpurge is not installed.' >&2
  apt-get install localepurge
else
  localepurge
fi
if [ $(type ncdu | wc -l) < 1 ]; then
  echo 'ncdu is not installed.' >&2
  apt-get install ncdu
else
  ncdu
fi
