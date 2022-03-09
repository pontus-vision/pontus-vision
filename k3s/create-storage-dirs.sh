#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

if [[ ! -d "${PV_STORAGE_BASE}" ]]; then 
mkdir "${PV_STORAGE_BASE}"
cd "${PV_STORAGE_BASE}"
tar xvfz ${DIR}/../sample-storage.tar.gz 
sudo chmod -R 777 *

fi

STORAGE_PATHS=$(helm template -s templates/pv-extract-cronjob.yaml -f ${PV_HELM_FILE}  pv ./helm/pv 2>/dev/null |yq -r .spec.hostPath.path| grep -v null)

for i in ${STORAGE_PATHS}; do 
  echo checking $i;
  if [[ ! -d $i ]]; then 
    echo creating missing dir $i;
    mkdir -p $i
    chmod 777 $i
  fi
done
