#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./create-env-secrets.sh

helm repo add jetstack https://charts.jetstack.io
helm repo update

#helm install \
#  cert-manager jetstack/cert-manager \
#  --namespace cert-manager \
#  --create-namespace \
#  --version v1.6.1 \
#  --set installCRDs=true
helm template cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.6.1 --set installCRDs=true | kubectl apply -f -
 
#helm install -f ./helm/values-prod.yaml pv-lgpd ./helm/pv-lgpd  
helm template -f ./helm/values-tst.yaml pv-lgpd ./helm/pv-lgpd  | kubectl apply -f -


#YAML_FILES=$(ls *.yaml | xargs | sed -e 's/ /,/g')

#kubectl apply -f $YAML_FILES

