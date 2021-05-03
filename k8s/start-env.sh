#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./create-env-secrets.sh

YAML_FILES=$(ls *.yaml|grep volume | xargs | sed -e 's/ /,/g')
kubectl apply -f $YAML_FILES

YAML_FILES=$(ls *.yaml|grep -v volume|grep -v service | xargs | sed -e 's/ /,/g')
kubectl apply -f $YAML_FILES

YAML_FILES=$(ls *.yaml |grep service | xargs | sed -e 's/ /,/g')
kubectl apply -f $YAML_FILES



