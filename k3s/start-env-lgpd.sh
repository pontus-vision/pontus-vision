#!/bin/bash  -x 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./create-env-secrets.sh

if [[ -z ${PV_HOSTNAME} ]]; then
  export PV_HOSTNAME=$(hostname)
fi
if [[ -z ${PV_STORAGE_BASE} ]]; then
  export PV_STORAGE_BASE=${DIR}/storage
fi
if [[ ! -d ${PV_STORAGE_BASE} ]]; then
 ./create-storage-dirs.sh
fi

cat ./helm/values-lgpd.yaml | envsubst > ./helm/values-lgpd-resolved.yaml

helm template -f ./helm/values-lgpd-resolved.yaml pv ./helm/pv | k3s kubectl apply -f -

