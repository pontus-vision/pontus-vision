#!/bin/bash

mkdir -p ~/work/client/
cd ~/work/client/
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

