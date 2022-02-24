#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./create-env-secrets.sh

helm template -f ./helm/values-lgpd.yaml pv ./helm/pv | k3s kubectl apply -f -

