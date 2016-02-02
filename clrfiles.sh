#!/bin/bash
for x in {a..z}{a..z}
do
  if [ $x != "en" ]; then
    rm -rf /usr/share/locale/${x}*
  else
    echo "Keeping $x"
  fi
done
