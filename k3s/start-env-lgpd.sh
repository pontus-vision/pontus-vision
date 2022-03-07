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

if [[ $0 =~ lgpd ]]; then
  export PV_IMAGE_SUFFIX=-pt
  export PV_MODE=lgpd
else
  export PV_IMAGE_SUFFIX=
  export PV_MODE=gdpr
fi


export PV_HELM_FILE=./helm/values-resolved.yaml
cat ./helm/custom-values.yaml | envsubst > $PV_HELM_FILE
./create-storage-dirs.sh


helm template -f ${PV_HELM_FILE} pv ./helm/pv | k3s kubectl apply -f -

