#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

./stern_linux_amd64  --tail 1000 -n default .
