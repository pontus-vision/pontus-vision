#!/bin/bash

export SNAP_LIST=$(snap list) && \
sudo ls

for i in 1 2; do
                                       
  for i in ${SNAP_LIST}; do
    sudo snap remove --purge $i
  done

  for i in ${SNAP_LIST}; do
    sudo snap remove --purge $i
  done

  sudo rm -rf /var/cache/snapd/

  yes | sudo apt autoremove --purge snapd gnome-software-plugin-snap

  rm -fr ~/snap &&  sudo apt-mark hold snapd

done

