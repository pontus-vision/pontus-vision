#!/bin/bash

helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install  cert-manager jetstack/cert-manager  --namespace cert-manager  --create-namespace  --version v1.6.1  --set installCRDs=true
                                
