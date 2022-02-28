#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./create-storage-dirs.sh
./create-env-secrets.sh

cat ./helm/values-gdpr.yaml | envsubst > ./helm/values-gdpr-resolved.yaml

helm template -f ./helm/values-gdpr-resolved.yaml pv ./helm/pv | k3s kubectl apply -f -
