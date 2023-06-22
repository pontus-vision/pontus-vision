#!/bin/bash

# update server & install tools
./pre-requisites/update_intall_tools.sh

# installing k3s
./pre-requisites/install_k3s.sh

# appending commands to .bashrc
./pre-requisites/append_k3s_bashrc.sh

# installing helm
./pre-requisites/install_helm.sh

# adding helm cert-manager
./pre-requisites/helm_cert_manager.sh

