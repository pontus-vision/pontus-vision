
# Pontus Vision

  [Pontus Vision](https://www.pontusvision.com) is an open source platform for data mapping and management of personal data. It helps companies comply with data protection regulations, such as the European Union's **GDPR**, Brazil's **LGPD** and California's State **CCPA**.

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

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/arch-components.png) <!-- update picture !! -->

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

  Gathers links to all personal data within an organisation, with graphical or textual reports, using a scoring system based on the ICO’s 12 steps to GDPR compliance.

  <details>

  All data is consolidated in a dashboard, for graphical or textual visualisation.

  The solution gathers links to all personal data within an organisation, with graphical or textual reports, using a scoring system based on the ICO’s 12 steps to GDPR compliance.

  All forms and reports are managed in real time, showing the areas of the organisation that have personal data.

</details>

<br/> 

## Architecture (Components)

  All Pontus Vision components have been created as docker containers; the following table summarises the key components:


  | Docker image                                         |Module   | Description                                     | Stateful            | Image Size | Min Memory |
  |------------------------------------------------------|---------|-------------------------------------------------|---------------------|------------|------------|
  |  pontusvisiongdpr/grafana:1.13.2                     |Comply   | Dashboard - historical KPIs and data tables     | Yes                 | 140.67MB   | 39MiB      |
  |  pontusvisiongdpr/pontus-comply-keycloak:latest      |Comply   | (optional) Authenticator - creates JWT token    | Yes                 | 404MB      | 492MiB     |
  |  pontusvisiongdpr/pontus-track-graphdb-odb:1.15.55    |Track    | Graph Database to store data in the POLE model  | Yes                 | 1.04GB     | 4.5GiB     |
  |  pontusvisiongdpr/timescaledb:latest                 |Track    | Historical time series database                 | Yes                 | 73MB       | 192MiB     |
  |  pontusvisiongdpr/postgrest:latest                   |Track    | REST API front end to timescale db              | No                  | 43MB       | 13MiB      |
  |  pontusvisiongdpr/pontus-extract-spacy:1.13.2        |Extract  | (optional) Natural language processor           | No                  | 4.12GB     | 105MiB     |
  |  pontusvisiongdpr/pv-extract-tika-server-lambda:1.13.2     |Extract  | Extraction of text from documents               | No                  | 436.2MB    | 255MiB     |
  |  pontusvisiongdpr/pv-extract-wrapper:1.13.2          |Extract  | Extract modules to get data from (Un)structured sources. Each data source will require a different instance  | No                  | 223.84 MB  |      23MiB    |

<br/>

# Pre-requisites

  - Linux Ubuntu 22.04
    - ensure that all packages are up to date
    - ensure that the `git` client is installed 
  - 8-core CPU            
  - 32GB RAM
  - 250GB Disk + ~1KB of storage / record


**Before hand, let's configure the machine with the necessary tools to run the Demo.**

Clone this repo:

  ```bash
  mkdir -p ~/work/client/
  cd ~/work
  git clone --depth=1 https://github.com/pontus-vision/pontus-vision.git
  cd pontus-vision/k3s

  ```

Then ...

**<details><summary>Remove Snap (optional - not required for WSL)</summary>**

  Remove `Snap` package manager, as it consumes too much CPU on small servers; this can be done by running the following:

  ```bash
  ./pre-requisites/remove_snap.sh
  ```

</details>

<!--
**<details><summary>Update the server and install tools:</summary>**

  ```
  sudo apt update
    #<enter your local ubuntu user password>
  
  sudo apt upgrade -y 
  sudo apt install -y git curl jq ubuntu-server python3-pip 
  pip3 install yq
                             
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
  chmod 700 get_helm.sh && \
  ./get_helm.sh
                                   
  ```

</details>

**<details><summary>Certificate Manager installation</summary>**

  After installing helm, create the cert-manager namespace and install cert manager; this will enable https certificates to be managed:

  ```
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  kubectl create namespace cert-manager
  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
  helm install  cert-manager jetstack/cert-manager  --namespace cert-manager  --create-namespace  --version v1.6.1  --set installCRDs=true
                                  
  ```

</details>
-->

Run this **COMPULSORY** script to config all pre-requisites:

> Attention! It may ask for SUDO password and other inputs!

  ```bash
  ./pre_requisites.sh
  # this updates and installs tools necessary for running this Demo,
  # for more details, cat and check it
  ```

<br/>

# Demo Installation

  The easiest way to deploy the Pontus Vision platform is to run a VM with Ubuntu 20.04/22.04 OS, with a minimum of 32GB of RAM, 8 cores and 250GB of disk space.

  Note that the VM must be called `pv-demo`; otherwise, Keycloak's rules will have to be changed to allow traffic from other prefixes.

<br/>

  > **WARNING**: Please ensure that the VM used for the demo is called **pv-demo** by running:

  ```bash
  hostnamectl set-hostname pv-demo
  ```

--------------------------------------------------------------------

  > _If you wish to mantain the hostname, then follow this steps:_
  
**<details><summary>Change the environment variable 'PV_HOSTNAME'</summary>**

Change the environment variable PV_HOSTNAME in the .bashrc (or equivalent) of the user that runs the start-up script (./start-env-gdpr.sh).  

```bash
  export PV_HOSTNAME="mydemo.myorg.com"
```
Note that you *MUST* use the exactly the same name here and in the next session.  Even if the change is just a domain name suffix, a URL like https://mydemo/pv, will not work; you must use exactly the same name as above (e.g. https://mydemo.myorg.com) both in the browser and in the next step.
  
</details>

**<details><summary>Change Keycloak URI redirection</summary>**

  To change the URI redirection on Keycloak, login as a **Super User**. To do so, go to the following link => [https://\<add-hostname-here\>/auth/](https://$\<add-hostname-here\>/auth/) and authenticate with admin default credential **username: admin / password: admin**.

  Here are some screenshots steps on how to change URI redirects:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Then click on **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > This is Keycloak's home page. Click on **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Enter the default credentials and click **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname2.png)

  > At the main panel, locate **Clients** under **Realm settings** on the left menu.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname3.png)

  > On the Clients table, click on **broker** Client ID.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname5.png)

  > On the Broker page scroll down till you see **Valid Redirect URIs**. The last value of this list will always be default `https://pv-demo/*`. Change it to `https://\<add-hostname-here\>/*`.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname9.png)

  > Scroll down and click on **Save** and wait for the **Success!** message popup.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname6.png)

  > Go back to the **Clients** page and click on the **test** Client ID and perform the same changes made on the **broker** Client ID.

  That should do it! Now you will be able to access the Dashboard using  [https://\<add-hostname-here\>/pv](https://$\<add-hostname-here\>/pv).

  **MAYBE AN ENVIRONMENT RESTART IS NEEDED**. Check the **Restart k3s env** section below.

</details>

--------------------------------------------------------------------

<br/>

  If you want to use your own data, you must configure secrets, apis and storage settings in the folders storage/ and secrets/, following the instructions in the next section THOROUGHLY.

  The helm chart used to configure the Pontus Vision platform exists in this repository. Clone this repository and use either the GDPR or LGPD Demo:

  > If you already ran **git clone**, skip this next command.

  ```bash
  mkdir -p ~/work/client/
  cd ~/work 
  git clone --depth=1 https://github.com/pontus-vision/pontus-vision.git
  cd pontus-vision/k3s
                                   
  ```

  To run the GDPR Demo, run the following command:

  ```bash
  ./start-env-gdpr.sh
  # Note: The command above may fail the first time,
  # as k3s will be dowloading large images and may time out.
  # If that happens, run it again
  ```

  Or... Run the following to start the LGPD Demo:

  ```bash
  ./start-env-lgpd.sh
  # Note: The command above may fail the first time,
  # as k3s will be dowloading large images and may time out.
  # If that happens, run it again
  ```

<br/>

# Custom Installation

  The easiest way to deploy the Pontus Vision platform is to run either a VM or bare-metal Ubuntu 20.04 OS, and follow the instructions below:

<br/>

  > **WARNING**: Please ensure that the VM used for the demo is called **pv-demo** by running: 
  
  ```bash
  hostnamectl set-hostname pv-demo
  ```

--------------------------------------------------------------------

  > _If you wish to mantain the hostname, then follow this steps:_

**<details><summary>Change Keycloak URI redirection</summary>**

  To be able to change the URI redirection on Keycloak, one needs to login as a **Super User**. To do so, go to the following link => [https://\<add-hostname-here\>/auth/](https://$\<add-hostname-here\>/auth/) and authenticate with admin default credential **username: admin / password: admin**.

  Here's some screenshots steps on how to change URI redirects:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Then click on **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > This is Keycloak's home page. Click on **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Enter the default credentials and click **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname2.png)

  > At the main panel, locate **Clients** under **Realm settings** on the left menu.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname3.png)

  > On the Clients table, click on **broker** Client ID.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname5.png)

  > On the Broker page scroll down till you see **Valid Redirect URIs**. The last value of this list will always be default `https://pv-demo/*`. Change it to `https://\<add-hostname-here\>/*`.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname9.png)

  > Scroll down and click on **Save** and wait for the **Success!** message popup.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname6.png)

  > Go back to the **Clients** page and click on the **test** Client ID and perform the same changes made on the **broker** Client ID.

  That should do it! Now you will be able to access the Dashboard using  [https://\<add-hostname-here\>/pv](https://$\<add-hostname-here\>/pv).

  **MAYBE AN ENVIRONMENT RESTART IS NEEDED**. Check the **Restart k3s env** section below.

</details>

--------------------------------------------------------------------

<br/>

  The helm chart used to configure the Pontus Vision platform exists in this repository. Clone this repository and use either the GDPR or LGPD Demo:

  > If you already ran **git clone**, skip this next command.

  ```bash
  mkdir -p ~/work/client/
  cd ~/work
  git clone --depth=1 https://github.com/pontus-vision/pontus-vision.git
  cd pontus-vision/k3s
                                    
  ```

**<details><summary>Secret Files</summary>**

  This Demo uses Kubernetes secrets to store various sensitive passwords and credentials. You'll need to create your own, but to get you started, we have created a `tar.gz` file with sample formats.
  
  > The `create-env-secrets.sh` script is in charge of the secrets.

  The first time the environment is started, it will check if there's a `secrets/` folder existing (in case you want to add privates), otherwise it will use `sample-secrets.tar.gz` by default. To create the folder in a compatible manner, follow below ↓

<br/>

**Edit the secret Files structure**

  You should organize a directory structure similar to the example down. Make sure to create the `secrets/` folder inside `k3s/`'s. Also, be consistent with the **secrets's variable names / Environment Variables**, as you will need to use them on the HELM `templates/` yaml files.
  
  > **WARNING**: Secrets located inside the env/ folder should ONLY be modified by EXPERIENCED USERS. Add your other secrets to the MAIN folder secrets/.

  Here's the tree structure of folders and files of the default `secrets/` generated via `sample-secrets.tar.gz`:

  ```bash
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
  ├── google-json # example                   
  └── microsoft-json # example                
  ```

  And this is the YAML template secret file for `pontus-timescaledb` @ `pontus-vision\k3s\helm\pv\templates` used by HELM-K3S. Notice how the secrets names `POSTGRES_USER` and `POSTGRES_PASSWORD` are used.

  ```yaml
  spec:
  containers:
  - env:
    - name: PGUSER
      value: postgres
    - name: POSTGRES_PASSWORD # <---
      valueFrom:
        secretKeyRef:
          name: pontus-timescaledb
          key: POSTGRES_PASSWORD # <---
    - name: POSTGRES_USER # <---
      valueFrom:
        secretKeyRef:
          name: pontus-timescaledb
          key: POSTGRES_USER # <---
    image: pontusvisiongdpr/timescaledb:latest
    name: pontus-timescaledb
  ```

  Here are other examples / templates of secrets:

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

  The values file `pontus-vision/k3s/helm/custom-values.yaml` has configuration details that vary from environment to environment. Here's an example:

  ```yaml
  # This is a YAML-formatted file.
  # Declare variables here to be passed to your templates.

  pvvals:
    imageVers:
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb${PV_IMAGE_SUFFIX}:1.15.55"
      grafana: "pontusvisiongdpr/grafana${PV_IMAGE_SUFFIX}:1.13.2"
      pvextract: "pontusvisiongdpr/pv-extract-wrapper:1.13.2"

    storagePath: "${PV_STORAGE_BASE}" # Environment Variable
    hostname: "${PV_HOSTNAME}"
    # to get the keycloak public key, do an HTTP GET to the following URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "*********************************************************"

    # change the values as necessary
    # Be consistent with the variables!
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

      # Add / modify your own cronjobs|pods|services
      # Be consistent with the variables!
      cronjob-1:
        command:
          - /usr/bin/node
          - dist/rest-handler/cronjob-1/app.js
        secretName: "cronjob-1-json"
        storage: "1Mi"
        env:
          - name:  PV_SECRET_MANAGER_ID
            value: "/run/secrets/cronjob-1-json"
          - name:  PV_REQUEST_URL
            value: "${CRONJOB-1_URL}"
          - name:  PV_GRAPHDB_INPUT_RULE
            value: "bb_mapeamento_de_processo"
          - name:  PV_SECRET_COMPONENT_NAME
            value: "cronjob-1"
          - name:  PV_GRAPHDB_INPUT_JSONPATH
            value: "$.rows"
  ```

<!-- ## `cd pv/templates` to configure the **cronjobs**. Is this part necessary ?!?! -->

<!--
TODO templates cronjob instructions
-->

<br/>

</details>

**<details><summary>Create persistent volumes storage</summary>**

  > This step is **AUTO PERFORMED** !!
  > To ensure it runs smoothly, guarantee you setted everything @ k3s\helm\custom-values.yaml !!

  This step is important to ensure k3s data is kept by using **persistent volumes**. The script `create-storage-dirs.sh` is executed when the environment (Demo) is started. It is responsible in creating the storage folder structure.

  The `extract/` inner folders are created using the `custom-values.yaml`'s map keys.

  Here's how it works:

  ```yaml
      kpi:
      command:
        - /bin/bash
        - -c
        - sleep 10 && getent hosts graphdb-nifi &&  /usr/bin/node dist/kpi-handler/app.js
      env:
        - name: PV_POSTGREST_PREFIX
          value: "http://pontus-postgrest:3000"

    # Name your cronjobs|pods|services accordingly
    cronjob-x: # <--- this will be the name of the folder @ /storage/extract/cronjob-x
      command:
        - /usr/bin/node
        - dist/rest-handler/cronjob-x/app.js
      secretName: "cronjob-x-json" # <---
      storage: "1Mi"
      env:
        - name:  PV_SECRET_MANAGER_ID
          value: "/run/secrets/cronjob-x-json" # <---
        - name:  PV_REQUEST_URL
          value: "${CRONJOB-X_URL}" # <---
        - name:  PV_GRAPHDB_INPUT_RULE
          value: "cronjob-x" # <---
        - name:  PV_SECRET_COMPONENT_NAME
          value: "cronjob-x" # <---
        - name:  PV_GRAPHDB_INPUT_JSONPATH
          value: "$.rows"
  ```

  Here's the resulting tree structure @ `/storage/extract`:

  ```bash
  ~/storage
  ├── db
  ├── extract
  │   └── cronjob-x # <---
  |       └── state.json # <---
  ├── grafana
  ├── keycloak
  └── timescaledb
  ```

</details>

<br/>

Only when configured the previous steps, go back to `pontus-vision/k3s` folder to play your custom Demo.

Run the following to start the GDPR custom Demo:

```bash
./start-env-gdpr.sh
# Note: The command above may fail the first time,
# as k3s will be dowloading large images and may time out.
# If that happens, run it again
```

Or... Run the following to start the LGPD custom Demo:

```bash
./start-env-lgpd.sh
# Note: The command above may fail the first time,
# as k3s will be dowloading large images and may time out.
# If that happens, run it again
```

<br/>

# Management

**Accessing Grafana (Pontus Vision Dashboard)**

  1. point a browser to [https://pv-demo/pv](https://pv-demo/pv)

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pv-demo-1.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pv-demo-2.png)

  > Then click on **Continue to pv-demo (unsafe)**.

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

  Pontus Vision is constantly upgrading and updating its container images to keep up with the latest tech and security patches. To change versions simply change the `pvvals.imageVers` value @ `pontus-vision/k3s/helm/custom-values.yaml` then restart k3s env (look bellow @ **Restart k3s env** section).

  ```yaml
  # This is a YAML-formatted file.
  # Declare variables here to be passed to your templates.

  pvvals:
    imageVers: # <---
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb${PV_IMAGE_SUFFIX}:1.15.55"
      grafana: "pontusvisiongdpr/grafana${PV_IMAGE_SUFFIX}:1.13.2"
      pvextract: "pontusvisiongdpr/pv-extract-wrapper:1.13.2"

    storagePath: "${PV_STORAGE_BASE}"
    hostname: "${PV_HOSTNAME}"
    # to get the keycloak public key, do an HTTP GET to the following URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "*********************************************************"

  # (...)
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

  > You may need to remove some inner folders from storage/
  > or the folder itself so current state.json files are deleted
  > and updates applied on next kickoff.

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

**<details><summary>Listing k3s nodes | pods | cronjobs | services</summary>**

  > For a listing of all nodes execute the command `$ kubectl get nodes`.

  ```
  NAME      STATUS   ROLES                  AGE    VERSION
  pv-demo   Ready    control-plane,master   3d2h   v1.22.7+k3s1
  ```

<br/>

  > To examine pods, run `$ kubectl get pod(s) [-o wide]` then a tab table alike is displayed:

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

<br/>
  
  > To get details from a specific pod run `$ kubectl describe pod(s) <pod name>`. Output for graphdb-nifi pod:

  ```
  Name:         graphdb-nifi
  Namespace:    default
  Priority:     0
  Node:         pv-demo/172.16.10.100
  Start Time:   Sat, 12 Mar 2022 20:38:36 +0000
  Labels:       io.kompose.network/pontusvision=true
                io.kompose.service=graphdb-nifi
  Annotations:  <none>
  Status:       Running
  IP:           10.42.0.154
  IPs:
    IP:  10.42.0.154
  Containers:
    graphdb-nifi:
      Container ID:   containerd://09aab7b7******************************
      Image:          pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.55
      Image ID:       docker.io/pontusvisiongdpr/pontus-track-graphdb-odb-pt@sha256:5182a463df6***********************
      Ports:          8183/TCP, 7000/TCP, 3001/TCP, 2480/TCP, 5007/TCP
      Host Ports:     0/TCP, 0/TCP, 0/TCP, 0/TCP, 0/TCP
      State:          Running
        Started:      Sat, 12 Mar 2022 20:38:41 +0000
      Ready:          True
      Restart Count:  0
      Environment:
        ORIENTDB_ROOT_PASSWORD:  <set to the key 'ORIENTDB_ROOT_PASSWORD' in secret 'pontus-graphdb'>  Optional: false
        PV_RIPD_ORG:             Pontus Vision
        PV_RIPD_DPO_NAME:        Senhora DPO
        PV_RIPD_DPO_EMAIL:       dpo@pontusvision.com
        PV_DSAR_DPO_NAME:        Senhora DPO
        PV_DSAR_DPO_EMAIL:       dpo@pontusvision.com
        PV_RIPD_DPO_PHONE:       555-2233-3344
        PV_USE_JWT_AUTH:         true
        PV_KEYCLOAK_PUB_KEY:     *****************************************************************************************************
      Mounts:
        /orientdb/backup from orientdb-data (rw,path="backup")
        /orientdb/databases from orientdb-data (rw,path="databases")
        /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2x5bv (ro)
  Conditions:
    Type              Status
    Initialized       True
    Ready             True
    ContainersReady   True
    PodScheduled      True
  Volumes:
    mapping-salesforce-graph:
      Type:        Secret (a volume populated by a Secret)
      SecretName:  mapping-salesforce-graph
      Optional:    false
    orientdb-data:
      Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
      ClaimName:  pontus-track-claim0
      ReadOnly:   false
    kube-api-access-2x5bv:
      Type:                    Projected (a volume that contains injected data from multiple sources)
      TokenExpirationSeconds:  3607
      ConfigMapName:           kube-root-ca.crt
      ConfigMapOptional:       <nil>
      DownwardAPI:             true
  QoS Class:                   BestEffort
  Node-Selectors:              <none>
  Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                              node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
  Events:
    Type    Reason     Age    From               Message
    ----    ------     ----   ----               -------
    Normal  Scheduled  6m19s  default-scheduler  Successfully assigned default/graphdb-nifi to pv-demo
    Normal  Pulling    6m16s  kubelet            Pulling image "pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.55"
    Normal  Pulled     6m14s  kubelet            Successfully pulled image "pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.55" in 1.834313572s
    Normal  Created    6m14s  kubelet            Created container graphdb-nifi
    Normal  Started    6m14s  kubelet            Started container graphdb-nifi
  ```

<br/>

  > To list all running cronjobs, run `$ kubectl get cronjobs(.batches)`.

  ```
  pv-extract-cronjob-treinamento                */7 * * * *   False     0        6m9s            9m33s
  pv-extract-cronjob-users                      */1 * * * *   False     1        9s              9m33s
  pv-extract-crm                                */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-acoes-judiciais-ppd        */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-fontes-de-dados            */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-aviso-privacidade          */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-mapeamento-de-processo     */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-politicas                  */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-mitigacao-de-riscos        */1 * * * *   False     1        9s              9m33s
  pv-extract-kpi                                */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-consentimentos             */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-comunicacoes-ppd           */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-controle-de-solicitacoes   */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-incidentes-de-seguranca    */1 * * * *   False     1        9s              9m33s
  pv-extract-cronjob-riscos                     */1 * * * *   False     1        9s              9m33s
  ```

<br/>

  > To show services type `$ kubectl get services`.

  ```
  NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                                                 AGE
  kubernetes               ClusterIP      10.43.0.1       <none>          443/TCP                                                 24h
  graphdb-nifi             ClusterIP      10.43.192.0     <none>          8182/TCP,8183/TCP,7000/TCP,3001/TCP,2480/TCP,5009/TCP   11m
  pontus-comply-keycloak   ClusterIP      10.43.162.253   <none>          8080/TCP                                                11m
  pontus-postgrest         ClusterIP      10.43.188.181   <none>          3000/TCP                                                11m
  spacyapi                 ClusterIP      10.43.167.32    <none>          80/TCP,8080/TCP                                         11m
  pv-extract-tika-server   ClusterIP      10.43.170.103   <none>          3001/TCP                                                11m
  pontus-timescaledb       ClusterIP      10.43.7.140     <none>          5432/TCP                                                11m
  pontus-grafana           LoadBalancer   10.43.141.52    172.16.10.100   3000:30357/TCP                                          11m
  pontus-gdpr              LoadBalancer   10.43.126.21    172.16.10.100   18443:31618/TCP                                         11m
  ```

</details>

**<details><summary>k3s logs</summary>**

  To get a specific pod's log run:

  ```
  kubectl logs [-f] <pod name> [--tail]
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

  > Then click on **Proceed to \<hostname\> (unsafe)**.

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

  Grafana is a multi-platform open source analytics and interactive visualisation web application. Connected with Pontus Vision's product, provides charts, graphs, and alerts on the web.

  The same **Super User** privilege is needed here ...go to the main login page [https://\<add-hostname-here\>/pv](https://\<add-hostname-here\>/pv) and enter the admin credentials sent by your administrator.

  Here's some screenshots steps on how to create a new user:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Then click on **Proceed to \<hostname\> (unsafe)**.

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

  > Then click on **Proceed to \<hostname\> (unsafe)**.

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
