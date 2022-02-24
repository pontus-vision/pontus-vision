#!/bin/bash

helm template -s templates/graphdb.yaml -f ./helm/values-test.yaml pv-lgpd ./helm/pv-lgpd | k3s kubectl apply -f -
