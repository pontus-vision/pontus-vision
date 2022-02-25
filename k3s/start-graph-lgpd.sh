#!/bin/bash

helm template -s templates/graphdb.yaml -f ./helm/values-lgpd.yaml pv ./helm/pv | k3s kubectl apply -f -
