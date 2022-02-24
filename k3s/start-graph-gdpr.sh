#!/bin/bash

helm template -s templates/graphdb.yaml -f ./helm/values-gdpr.yaml pv ./helm/pv | k3s kubectl apply -f -
