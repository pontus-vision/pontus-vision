#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

if [[ ! -d "${PV_STORAGE_BASE}" ]]; then 
mkdir "${PV_STORAGE_BASE}"
cd "${PV_STORAGE_BASE}"
tar xvfz ${DIR}/../sample-storage.tar.gz 
sudo chmod -R 777 *

fi
