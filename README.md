
# Pontus Vision

  [Pontus Vision](https://www.pontusvision.com) is an open source platform for data mapping and management of personal data. It helps companies comply with data protection regulations, such as EU's **GDPR**, Brazil's **LGPD** and California's **CCPA**.

<br/>

## Why PontusVision

Pontus Vision has the following benefits:

  * Unstructured and Structured data extraction
  * Compliance Dashboard with the ICO’s 12 Steps
  * Consent Management, including APIs to ensure compliance
  * Graphical or textual reports of all natural persons’ data
  * Real-time reports of all areas with natural person records
  * Data Privacy Impact Assessment (DPIA Management)
  * Data breach Analysis and Reports
  * Custom Forms and Dashboards
  * Can be deployed on prem/cloud (self hosted), or used as SaaS

<br/>

## Architecture (Modules)

  The Pontus Vision platform solves data mapping and management of personal data challenges in 3 modules:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/arch-components.png)

### EXTRACT

  Extract Structured Personal Data in Databases, CRM, ERP, and proprietary systems. Also works with unstructured data, such as, emails, PDFs, Word, and Excel.

<details>

  The Pontus Vision platform extracts structured and unstructured data in an automated manner and without interference on daily operations. The solution does not require changes to the customers’ systems, being able to receive large volumes of data from several corporate systems. Connectors for systems not yet supported are easily implemented.

  Structured Data: Databases, CRM, ERP and proprietary systems.
  Unstructured Data: emails, Microsoft Office documents, PDF files, and others.

</details>

### TRACK

  Maps all the data from the Extract module, identifying natural persons with as little data as possible, scalable to trillions of records.

  <details>

  Our solution maps data by tracking all data sources from the Extract stage, identifying customer data with as little information as possible, using graph databases and natural language processing technologies, supporting trillions of records.

  Scalability is extremely important as the number of data on natural persons grows daily, with each customer or staff interaction generating new data.

  Pontus Vision is based on the **POLE** (Person, Object, Location, Event) data model to Track data. This is a model used by the UK Government to associate data with individuals. The POLE model creates relationships between People, Objects, Locations and Events, forming the basis of a robust intelligence structure.

  </details>

### COMPLY

  Gathers links to all personal data within an organization, with graphical or textual reports, using a scoring system based on the ICO’s 12 steps to GDPR compliance.

  <details>

  All data is consolidated in a dashboard, for graphical or textual visualization.

  The solution gathers links to all personal data within an organization, with graphical or textual reports, using a scoring system based on the ICO’s 12 steps to GDPR compliance.

  All forms and reports are managed in real time, showing the areas of the organization that have personal data.

</details>

<br/> 

## Architecture (Components)

  All Pontus Vision components have been created as docker containers; the following table summarises the key components:


  | Docker image                                         |Module   | Description                                     | Stateful            | Image Size | Min Memory |
  |------------------------------------------------------|---------|-------------------------------------------------|---------------------|------------|------------|
  |  pontusvisiongdpr/grafana:1.13.2                     |Comply   | Dashboard - historical KPIs and data tables     | Yes                 | 140.67MB   | 39MiB      |
  |  pontusvisiongdpr/pontus-comply-keycloak:latest      |Comply   | (optional) Authenticator - creates JWT token    | Yes                 | 404MB      | 492MiB     |
  |  pontusvisiongdpr/pontus-track-graphdb-odb:1.15.13    |Track    | Graph Database to store data in the POLE model  | Yes                 | 1.04GB     | 4.5GiB     |
  |  pontusvisiongdpr/timescaledb:latest                 |Track    | Historical time series database                 | Yes                 | 73MB       | 192MiB     |
  |  pontusvisiongdpr/postgrest:latest                   |Track    | REST API front end to timescale db              | No                  | 43MB       | 13MiB      |
  |  pontusvisiongdpr/pontus-extract-spacy:1.13.2        |Extract  | (optional) Natural language processor           | No                  | 4.12GB     | 105MiB     |
  |  pontusvisiongdpr/pv-extract-tika-server-lambda:1.13.2     |Extract  | Extraction of text from documents               | No                  | 436.2MB    | 255MiB     |
  |  pontusvisiongdpr/pv-extract-wrapper:1.13.2          |Extract  | Extract modules to get data from (Un)structured sources. Each data source will require a different instance  | No                  | 223.84 MB  |      23MiB    |

<br/>

# Pre-requisites

  - Linux Ubuntu 20.04
    - ensure that all packages are up to date
    - ensure that the `git` client is installed 
  - 8-core CPU            
  - 32GB RAM
  - 250GB Disk + ~1KB of storage / record

**<details><summary>Removing Snap (optional - not required for WSL)</summary>**

  Before the `k3s` installation, remove `Snap` package manager, as it consumes too much CPU on small servers; this can be done by running the following:

  ```bash
  export SNAP_LIST=$(snap list)
  sudo ls
  ```

**run the loops below twice; this is NOT A TYPO:**

  ```bash
  for i in ${SNAP_LIST}; do
    sudo snap remove --purge $i
  done

  for i in ${SNAP_LIST}; do
    sudo snap remove --purge $i
  done

  sudo rm -rf /var/cache/snapd/

  yes | sudo apt autoremove --purge snapd gnome-software-plugin-snap

  rm -fr ~/snap
  sudo apt-mark hold snapd
  
  #Update the server:
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git curl ubuntu-server python3-pip
  sudo pip3 install yq
  ```

</details>

**<details><summary>Lightweight Kubernetes (k3s) installation</summary>**

  K3s is a Lightweight Kubernetes that is easy to install, and uses fewer resources than k8s. For more info follow the [link](https://github.com/k3s-io/k3s/blob/master/README.md).

  ```bash
  mkdir -p ~/work/client/
  cd ~/work/client/
  curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
  ```

  Note: when using WSL the following error message will appear, but can be safely ignored:
  
   > System has not been booted with systemd as init system (PID 1). Can't operate. <br/>
   > Failed to connect to bus: Host is down

  After running the commands above, add the following to the end of the `.bashrc` file:

  ```bash
  alias kubectl='k3s kubectl'
  source <(kubectl completion bash)
  export SCREENDIR=$HOME/.screen
  [ -d $SCREENDIR ] || mkdir -p -m 700 $SCREENDIR

  complete -C '/usr/local/bin/aws_completer' aws

  export PATH=$PATH:~/.local/bin:~/.yarn/bin:/mnt/c/Users/LeonardoMartins/go/bin/:$HOME/go/src/github.com/lexicality/wsl-relay/scripts
  #PROMPT_COMMAND='echo -ne "\033k\033\0134\033k${HOSTNAME}[`basename ${PWD}`]\033\0134"'
  #PROMPT_COMMAND='printf "\033k%s $\033\\" "${PWD/#$HOME/\~}"'
  PS1='\u@\h [\w] \$ '

  #if echo $TERM | grep ^screen -q; then
    #PS1='\[\033k\033\\\]'$PS1
  #fi
  if [[ "$TERM" == screen* ]]; then
    screen_set_window_title () {
    local HPWD="$PWD"
    case $HPWD in
      $HOME) HPWD="~";;
      $HOME/*) HPWD="~${HPWD#$HOME}";;
    esac
    printf '\ek%s\e\\' "$HPWD"
    }
    PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
  fi
  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
  export EDITOR=/usr/bin/vi
  ```

  Source the .bashrc above to apply the changes:
  ```
  . ~/.bashrc
  ```

</details>

**<details><summary>HELM installation</summary>**

  HELM is a tool that streamlines installing and managing Kubernetes applications. To install it, run the following code:

  ```bash
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  ```

</details>

**<details><summary>Certificate Manager installation</summary>**

  After installing helm, create the cert-manager namespace and install cert manager; this will enable https certificates to be managed:
  ```
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  kubectl create namespace cert-manager
  helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.6.1 \
    --set installCRDs=true
  ```
</details>

<br/>

# Pontus Vision Solution installation

  The easiest way to deploy the Pontus Vision platform is to run either a VM or bare-metal Ubuntu 20.04 OS, and follow the instructions below:

```diff
+ This Demonstration runs over a fictitious database so you can test Pontus Vision's tools handily.
+ All you have to do after clonning this GitHub repo is running the start-up scripts.
+ Skip all the way to the bottom of this section.
```

```diff
- If you want to try own data, then configuration of secrets, apis and storage will be required.
- Overwrite the folders storage/ and secrets/ following the instructions thoroughly.
```

  The helm chart used to configure the Pontus Vision platform exists in this repository. Clone this repository and use either the GDPR or LGPD Demo:

  ```bash
  git clone https://github.com/pontus-vision/pontus-vision.git
  cd pontus-vision/k3s
  ```

**<details><summary>Secret Files</summary>**

  This Demo uses Kubernetes secrets to store various sensitive passwords and credentials. You'll need to create your own, but to get you started, we have created a `tar` file with sample formats.

  To download and extract the sample secrets run the following command:
  ```
  ./download-sample-secrets.sh
  ```

**Edit the secret Files structure**

  That should produce a directory structure similar to the one below. Secrets located inside the `env/` folder should only be modified by experienced users; add your other secrets to the main folder `secrets/`.

  ```
  k3s/secrets/
  ├── crm-api-key                   
  ├── crm-json                      
  ├── env                           
  │   ├── pontus-grafana            
  │   │   └── GF_PATHS_CONFIG       
  │   ├── pontus-graphdb            
  │   │   ├── AWS_ACCESS_KEY_ID     
  │   │   ├── AWS_SECRET_ACCESS_KEY 
  │   │   └── ORIENTDB_ROOT_PASSWORD
  │   ├── pontus-postgrest          
  │   │   ├── PGRST_DB_ANON_ROLE    
  │   │   └── PGRST_DB_URI          
  │   └── pontus-timescaledb        
  │       ├── POSTGRES_PASSWORD     
  │       └── POSTGRES_USER         
  ├── erp-api-key                   
  ├── google-json                   
  └── microsoft-json                
  ```

<details><summary>crm-api-key</summary>

  This token is used to grant access to CRM's data. For more information on how to get this value, please contact DPO.

  **Format**: one-line text.

</details>

<details><summary>crm-json</summary>

  This json contains CRM's user key. For more information on how to get this value, please contact DPO.

  **Json format:**

  ```json
  {
    "secrets": {
      "crm": {
        "User-Key": "**************************************************************"
      }
    }
  }
  ```

</details>

<details><summary>env/pontus-grafana/GF_PATHS_CONFIG</summary>

  **Description:**

  Path to the grafana configuration file.

  **Default:** 
  ```
  /etc/grafana/grafana-pontus.ini
  ```

</details>

<details><summary>env/pontus-graphdb/ORIENTDB_ROOT_PASSWORD</summary>

  **Description:**
    
  Master password file for orient db.

  **Default:**
  ```
  admin
  ```

</details>

<details><summary> env/pontus-postgrest/PGRST_DB_ANON_ROLE </summary>

  **Description:**
    
  Role used to connect from postgrest to postgres (used to store time series data).

  **Default:**
  ```
  postgres
  ```

</details>

<details><summary> env/pontus-postgrest/PGRST_DB_URI</summary>

  **Description:**
    
  URI used for Postgrest to talk to TimescaleDB. Make sure that the password matches env/pontus-timescaledb/POSTGRES_PASSWORD.

  **Default:**
  ```
  postgres://postgres:mysecretpassword@pontus-timescaledb:5432/dtm
  ```

</details>

<details><summary> env/pontus-timescaledb/POSTGRES_PASSWORD</summary>

  **Description:**
    
  TimescaleDB's admin password.

  **Default:**
  ```
  mysecretpassword
  ```

</details>

<details><summary> env/pontus-timescaledb/POSTGRES_USER</summary>

  **Description:**
    
  TimescaleDB's admin username.

  **Default:**
  ```
  postgres
  ```

</details>

<details><summary>erp-api-key</summary>

  This token is used to grant access to ERP's data. For more information on how to get this value, please contact IT.

  **Format**: one-line text.

</details>

<details><summary>google-json</summary>

  This json has Google's secrets for connection. For more information on how to get those values, please contact IT.

  **Json format:**

  ```json
  {
    "secrets": {
      "google": {
        "X-SNY-API-AppKey": "xxxxxxxxxxxxx",
        "X-SNY-API-AppToken": "yyyyyyyyyyyyyyyyyyyyyyyy"
      }
    }
  }
  ```

</details>

<details><summary>microsoft-json</summary>

  This json holds credentials to access the company's Microsoft account and its stored data.

  **Json format:**

  ```json
  {
    "clientId": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "clientSecret": "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
    "tenantId": "zzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
  }
  ```

  Here's the instructions on how to get those credentials from Azure.

#### Azure API keys instructions:

<!-- add .pdf version -->

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-1.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-2.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-3.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-4.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-5.jpg)

</details>

</details>

**<details><summary>Configure the helm values</summary>**

  The values file `pontus-vision/k3s/helm/custom-values.yaml` have configuration details that vary from environment to environment. Here's an example:

  ```yaml
  # This is a YAML-formatted file.
  # Declare variables here to be passed to your templates.

  pvvals:
    imageVers:
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb${PV_IMAGE_SUFFIX}:1.15.14"
      grafana: "pontusvisiongdpr/grafana${PV_IMAGE_SUFFIX}:1.13.2"
      pvextract: "pontusvisiongdpr/pv-extract-wrapper:1.13.2"

    storagePath: "${PV_STORAGE_BASE}"
    hostname: "${PV_HOSTNAME}"
    # to get the keycloak public key, do an HTTP GET to the following URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "*********************************************************"

    defEnvVars:
      - name: PV_DEBUG
        value: "true"
      - name: PV_TIMEOUT_MS
        value: "1600000"
      - name: PV_GRAPHDB_URL_PREFIX
        value: http://graphdb-nifi:3001
      - name: PV_STATE_FILE
        value: "/mnt/pv-extract-lambda/state.json"
      - name: PV_SHAREPOINT_SITE_ID
        value: "some.sharepoint.com,<GUID1>,<GUID2>"
      - name: PV_OFFICE_365_ONPREM_CREDS_FILE
        value: "/run/secrets/sharepoint-json"
      - name:  PV_MAX_EMAIL_MESSAGES
        value: "1000"

    extractModules:
      kpi:
        command:
          - /bin/bash
          - -c
          - sleep 10 && getent hosts graphdb-nifi &&  /usr/bin/node dist/kpi-handler/app.js
        env:
          - name: PV_POSTGREST_PREFIX
            value: "http://pontus-postgrest:3000"

      budibase-mapeamento-de-processo:
        command:
          - /usr/bin/node
          - dist/rest-handler/budibase/app.js
        secretName: "budibase-json"
        storage: "1Mi"
        env:
          - name:  PV_SECRET_MANAGER_ID
            value: "/run/secrets/budibase-json"
          - name:  PV_REQUEST_URL
            value: "${BUDIBASE_URL_MAPEAMENTO_DE_PROCESSO}"
          - name:  PV_GRAPHDB_INPUT_RULE
            value: "bb_mapeamento_de_processo"
          - name:  PV_SECRET_COMPONENT_NAME
            value: "budibase"
          - name:  PV_GRAPHDB_INPUT_JSONPATH
            value: "$.rows"
  ```

## `cd pv/templates` to configure the **cronjobs**. <!-- Is this part necessary ?!?! -->

<!--
TODO templates cronjob instructions
-->

<br/>

</details>

**<details><summary>Create persistent volumes storage</summary>**

  This step is important to ensure k3s data is kept by using **persistent volumes**. To do so, please create a directory structure similar to the following:

  ```
  ~/storage
  ├── db
  ├── extract
  │   ├── CRM
  │   ├── ERP
  │   ├── email
  │   ├── google
  │   │   ├── meetings
  │   │   ├── policies
  │   │   ├── privacy-docs
  │   │   ├── privacy-notice
  │   │   ├── risk
  │   │   ├── risk-mitigations
  │   │   └── treinamentos
  │   └── microsoft
  │       ├── data-breaches
  │       ├── dsar
  │       ├── fontes-de-dados
  │       ├── legal-actions
  │       └── mapeamentos
  ├── grafana
  ├── keycloak
  └── timescaledb
  ```

  Make sure that the value for the `storagePath` key @ `pontus-vision/k3s/helm/values-gdpr.yaml` and `pontus-vision/k3s/helm/values-lgpd.yaml` is the root of the directory structure above.
  	
  Here is a set of commands that can create this structure if the value of `.Values.pvvals.storagePath` is set to `~/storage`:
    
  ```bash
  mkdir ~/storage
  cd ~/storage
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
  
  chmod -R 777 *
  ```	

</details>

<br/>

Only when configured the previous steps, go back to `pontus-vision/k3s` folder to play the Demo.

Run the following to start the GDPR Demo:

```bash
./start-env-gdpr.sh
# Note: The command above may fail the first time, as k3s will be dowloading large images and may time out.
```

Or... Run the following to start the LGPD Demo:

```bash
./start-env-lgpd.sh
# Note: The command above may fail the first time, as k3s will be dowloading large images and may time out.
```

<br/>

# Management

wait for all pods to be READY/ PULLED / CREATED then run the demo

**Accessing Grafana (Pontus Vision Dashboard)**

  1. point a browser to [https://localhost/pv](https://localhost/pv)
  2. Use the user name `lmartins@pontusnetworks.com` and the default password `pa55word!!!`

<br/>

## Start

**<details><summary>Start whole environment</summary>**

  Run the start-env-xxx.sh script:

  ```bash
  ./start-env-gdpr.sh # GDPR Demo
  ```

  or 

  ```bash
  ./start-env-lgpd.sh # LGPD Demo
  ```

</details>

**<details><summary>Start GraphDB</summary>**

  Run the start-graph-xxx.sh script:

  ```bash
  ./start-graph-gdpr.sh # GDPR Demo
  ```

  or

  ```bash
  ./start-graph-lgpd.sh # LGPD Demo
  ```

</details>

<br/>

## Updates

  <!-- ### PV cronjob container's Versions

  Make sure to always have the `:latest` container cronjob running, copy the below to `crontab -e`:

  ```
  00 00 * * * git pull
  00 01 * * * env -i helm tamplate
  ```  
  -->

**<details><summary>Pontus Vision imageVers</summary>**

  Pontus Vision is constantly upgrading and updating its container images to keep up with the latest tech and security patches. To change versions simply change the `pvvals.imageVers` value @ `pontus-vision/k3s/helm/values-gdpr.yaml` and `pontus-vision/k3s/helm/values-lgpd.yaml` then restart k3s env (look bellow @ **Restart k3s env** section).

  **Json File**:

  ```yaml
  pvvals:
    imageVers:
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb:1.15.13"
      grafana: "pontusvisiongdpr/grafana:1.13.2"
      # container: M.m.p
      # etc.
    storagePath: "<add path here>" # make sure to pass the exact path (Create persistent volumes storage section)
    hostname: "<add hostname here>"
    ErpUrlPrefix: "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    # to get the keycloak public key, do an HTTP GET to the following URL: https1://<hostname>/auth/realms/pontus
    keycloakPubKey: "******************************************"  
  ```

</details>

**<details><summary>Secrets</summary>**

  To update any secrets or credentials, go to the `pontus-vision/k3s/secrets` folder, update the relevant files, and restart k3s env (look bellow @ **Restart k3s env** section) to update the secrets's values.

</details>

**<details><summary>Restart k3s env</summary>**

#### Shutting down

  To stop the whole environment, run the following command: 
  ```
  ./stop-env.sh 
  ```

#### Starting up

  To start the whole environment, run the following command:

  For GDPR Demo:
  ```
  ./start-env-gdpr.sh
  ```

  For LGPD Demo:
  ```
  ./start-env-lgpd.sh
  ```

</details>

<br/>

## Monitoring/Troubleshooting

**<details><summary>Listing k3s pods</summary>**

  To do so type `$ kubectl get pods` then a tab table alike is displayed:

  ```
  NAME                                                       READY   STATUS              RESTARTS   AGE  
  svclb-pontus-grafana-t9m6w                                 1/1     Running             0          91m  
  svclb-pontus-gdpr-2jx9g                                    1/1     Running             0          91m  
  pontus-gdpr                                                1/1     Running             0          91m  
  pontus-grafana                                             1/1     Running             0          91m  
  pontus-comply-keycloak                                     1/1     Running             0          91m  
  pv-extract-tika-server                                     1/1     Running             0          91m  
  pontus-timescaledb                                         1/1     Running             0          91m  
  pontus-postgrest                                           1/1     Running             0          91m  
  spacyapi                                                   1/1     Running             0          91m  
  graphdb-nifi                                               1/1     Running             0          91m  
  pv-extract-kpi-27382396--1-9ftkf                           0/1     Completed           0          6m42s
  pv-extract-microsoft-dsar-27382401--1-drgw5                0/1     ContainerCreating   0          115s 
  pv-extract-microsoft-data-breaches-27382399--1-nr9nr       0/1     Completed           0          3m49s
  pv-extract-google-risk-27382399--1-mvbst                   0/1     Completed           0          3m23s
  pv-extract-crm-27382399--1-49r4x                           0/1     Completed           0          3m18s    
  pv-extract-google-risk-27382401--1-hndt9                   0/1     ContainerCreating   0          73s  
  pv-extract-microsoft-fontes-de-dados-27382399--1-drmnh     0/1     Completed           0          3m7s 
  pv-extract-microsoft-mapeamentos-27382402--1-rt6wq         0/1     ContainerCreating   0          38s  
  pv-extract-erp-27382400--1-j6zp9                           0/1     Completed           0          2m44s
  pv-extract-kpi-27382400--1-2hcl8                           1/1     Running             0          2m36s
  pv-extract-google-risk-mitigations-27382400--1-nmfcc       0/1     Completed           0          2m35s
  pv-extract-google-treinamentos-27382400--1-gr6gk           0/1     Completed           0          2m29s
  pv-extract-google-policies-27382402--1-9j4tg               0/1     ContainerCreating   0          12s  
  ```

</details>

**<details><summary>k3s logs</summary>**

  To get a specific pod's log run:

  ```
  kubectl logs [-f] <NAME> [--tail]
  ```

  To follow the logging, toggle flag `-f`. And to show the most recent logs use the flag `--tail` passing the number. For example:

  ```
  $ kubectl logs graphdb-nifi --tail=10

  failed to find translation conf/i18n_pt_translation.json: Data Procedures Per Data Source
  failed to find translation conf/i18n_pt_translation.json: RH03 (colaboradora Andreza) e RH04 (colaboradora Paula)
  failed to find translation conf/i18n_pt_translation.json: Data Procedures Per Data Source
  failed to find translation conf/i18n_pt_translation.json: (Local?)
  failed to find translation conf/i18n_pt_translation.json: Data Procedures Per Data Source
  failed to find translation conf/i18n_pt_translation.json: (verificar qual caminho)
  failed to find translation conf/i18n_pt_translation.json: Data Procedures Per Data Source
  NLP searching for matches for 12 names, 0 cpfs, 0 emails in file null
  NLP found 0 graph person matches on cust id or name from file null
  Failed to find any NLP events for file null
  ```

</details>

**<details><summary>kubectl taint</summary>**

  **Taints** allow a node to repel a set of pods, but this can prevent some pods from running. For more information click this [link](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

  If you get an **ERROR** like the one marked in the image, when running `$ kubectl describe pods <pod name>`: 

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/k3s-taint-1.png)

  OR, when running `$ kubectl describe nodes <node name>` the **Taints** section is different than `<none>`:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/k3s-taint-2.png)

  Then copy the Taints that were shown for the specific node and run the following command to **untain** each one of them:

  ```
  kubectl taint nodes <node name> [Taint]-
  ```

  For example:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/k3s-taint-3.png)

</details>

**<details><summary>$ top</summary>**

  To display Linux processes use the command `top`. Then press number `1` to toggle the CPU's cores, something alike will show:

  ```
  $ top (then press 1)

  top - 20:55:32 up 6 days,  2:55,  9 users,  load average: 21.22, 18.36, 17.10     
  Tasks: 582 total,   2 running, 580 sleeping,   0 stopped,   0 zombie              
  %Cpu0  : 90.3 us,  9.4 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  0.3 si,  0.0 st   
  %Cpu1  : 91.6 us,  7.8 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  0.6 si,  0.0 st   
  %Cpu2  : 86.6 us, 12.4 sy,  0.0 ni,  0.3 id,  0.7 wa,  0.0 hi,  0.0 si,  0.0 st   
  %Cpu3  : 93.2 us,  6.1 sy,  0.0 ni,  0.0 id,  0.6 wa,  0.0 hi,  0.0 si,  0.0 st   
  MiB Mem :  28373.9 total,   1409.1 free,  12102.7 used,  14862.0 buff/cache       
  MiB Swap:   2048.0 total,   2045.9 free,      2.1 used.  15652.1 avail Mem        
                                                                                    
      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND    
  2303232 cbrandao  20   0  155568  94308   9132 R 200.7   0.3   0:22.38 tesseract  
  1818371 root      20   0 4230816   1.8g 816244 S 105.3   6.3   3244:11 containerd 
  1573465 cbrandao  20   0   30.0g   4.3g  23804 S  38.5  15.4 426:41.78 java       
  1818293 root      20   0 2111024   1.0g 108884 S  30.3   3.8   2609:02 k3s-server 
  2303370 cbrandao  20   0  904248  64648  31440 S   4.3   0.2   0:01.43 node       
  ```

  <!-- **us** - Time spent in user space
  **sy** - Time spent in kernel space
  **ni** - Time spent running niced user processes (User defined priority)
  **id** - Time spent in idle operations -->
  Pay special attention to `wa` (Time spent on waiting I/O), the lower the better!
  <!-- **hi** - Time spent handling hardware interrupt routines. (Whenever a peripheral unit want attention form the CPU, it literally pulls a line, to signal the CPU to service it)
**si** - Time spent handling software interrupt routines. (a piece of code, calls an interrupt routine...)
**st** - Time spent on involuntary waits by virtual cpu while hypervisor is servicing another processor (stolen from a virtual machine) -->

</details>

<br/>

## User creation

**<details><summary>Keycloak</summary>**

  Keycloak is an open source software product used with Pontus Vision solutions to allow single sign-on with Identity and Access Management. 

  To be able to add/update/change users on Keycloak, one needs to login as a **Super User**. To do so, go to the following link => [https://\<add-hostname-here\>/auth/](https://$\<add-hostname-here\>/auth/) and authenticate with admin default credential **username: admin / password: admin**.

  Here's some screenshots steps on how to create a new user:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Then click on **Proceed(Continue) to \<hostname\>**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > This is Keycloak's home page. Click on **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Enter the default credentials and click **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-c.png)

  > At the main panel, locate **Users** under **Manage** on the left menu.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-3.png)

  > On the far right, click **Add user**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-5.png)

  > Fill in the fields (the mandatory at least) \**ID is auto incremented*. You can also add **User actions**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-6.png)

  > Finally, click on **Save**.

</details>

**<details><summary>Grafana</summary>**

  Grafana is a multi-platform open source analytics and interactive visualization web application. Connected with Pontus Vision's product, provides charts, graphs, and alerts on the web.

  The same **Super User** privilege is needed here ...go to the main login page [https://\<add-hostname-here\>/pv](https://\<add-hostname-here\>/pv) and enter the admin credentials sent by your administrator.

  Here's some screenshots steps on how to create a new user:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Then click on **Proceed(Continue) to \<hostname\>**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-1.png)

  > Enter the admin credentials then click **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-2.png)

  > Grafana's main page is as shown. Locate the **Shield** icon (Server Admin), under it, click on **Users**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-3.png)

  > A table containing all registered Uers wil appear. On the upper right corner, click on the blue **New user** button.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-4.png)

  > Fill in the fields (mandatory at least), then click the blue **Create user** button.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-5.png)

  > By clicking on the newly created user you can edit its Information, Permissions, Organisations it belongs and open Sessions.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-6.png)

  > To change a User's role in an Organisation, click on **Change role** *(Under Organisations)*, choose the role from the drop-down menu, then click **Save**.

</details>

<br/>

## password reset

**<details><summary>Instructions</summary>**

  To reset a user's password, one only needs to change it using Keycloak single sign-on and access management. Go to the following link => [https://\<add-hostname-here\>/auth/](https://\<add-hostname-here\>/auth/) and authenticate with admin default credential **username: admin / password: admin**.

  Here's some screenshots steps on how to reset a user's password:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Then click on **Proceed(Continue) to \<hostname\>**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > This is Keycloak's home page. Click on **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Enter the default credentials and click **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-c.png)

  > At the main panel, locate **Users** under **Manage** on the left menu.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-4.png)

  > Click on **View all users** next to the search bar. Then a table containing all registered users will show. On the **Actions** column click on **Edit**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-1.png)

  > Change the upper tab to **Credentials**. Then under **Reset Password** type the new password.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-2.png)

  > You can toggle the **Temporary** button, to force the user to change the password once he logs in for the first time.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-3.png)

  > Then click the **Reset Password** button. A popup will show to confirm the change. Click the red **Reset password** button.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-4.png)

  > After loading, the page will reload and a green popup will appear with the message **Success**.

</details>
