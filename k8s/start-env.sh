#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./create-env-secrets.sh
YAML_FILES=$(ls *.yaml | xargs | sed -e 's/ /,/g')

kubectl apply -f $YAML_FILES

