#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

curl -sfL https://github.com/pontus-vision/pontus-vision/raw/main/sample-secrets.tar.gz | tar xzvf -
