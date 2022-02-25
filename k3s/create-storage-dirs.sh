#!/bin/bash 

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

if [[ ! -d "${PV_STORAGE_BASE}" ]]; then 
mkdir "${PV_STORAGE_BASE}"
cd "${PV_STORAGE_BASE}"
mkdir -p extract/email \
    extract/CRM \
    extract/ERP \
    extract/microsoft/data-breaches \
    extract/microsoft/dsar \
    extract/microsoft/fontes-de-dados \
    extract/microsoft/legal-actions \
    extract/microsoft/mapeamentos \
    extract/google/meetings \
    extract/google/policies \
    extract/google/privacy-docs \
    extract/google/privacy-notice \
    extract/google/risk \
    extract/google/risk-mitigations \
    extract/google/treinamentos \
  db \
  grafana \
  keycloak \
  timescaledb

sudo chmod -R 777 *

fi
