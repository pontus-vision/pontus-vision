#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

if [[ ! -d secrets ]]; then
  tar xvfz ../sample-secrets.tar.gz 

fi

for i in secrets/env/*; do 
  export SECRET_NAME=$(echo $i | sed -e 's#secrets/env/##g') 
  cd $i
  export COMMAND="k3s kubectl create secret generic $SECRET_NAME "
  for j in *; do
    export SECRET_KEY=$j
    export COMMAND="$COMMAND --from-file=$SECRET_KEY"
  done  
  echo "$COMMAND"
  if [[ "skip" != "$1" ]]; then
    $COMMAND --dry-run=client -o yaml | k3s kubectl apply -f -

  fi
  cd $DIR

done

for i in secrets/*; do
  if [[ ! -d $i ]]; then
    export SECRET_NAME=$(echo $i | sed -e 's#secrets/##g') 
    cd $DIR/secrets
    export COMMAND="k3s kubectl create secret generic $SECRET_NAME --from-file=$SECRET_NAME"
    echo "$COMMAND"
    if [[ "skip" != "$1" ]]; then
      $COMMAND --dry-run=client -o yaml | k3s kubectl apply -f -
    fi
    cd $DIR
  fi
done
