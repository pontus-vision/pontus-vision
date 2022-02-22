
# Pontus Vision

[Pontus Vision](https://www.pontusvision.com) is an open source platform for data mapping and management of personal data. It helps companies comply with data protection regulations, such as California's **CCPA**, Brazil's **LGPD** and EU's **GDPR**.

## Why PontusVision
Pontus Vison has the following benefits:

 * Unstructured and Structured data extraction
 * Compliance Dashboard with the ICO’s 12 Steps
 * Consent Management, including APIs to ensure compliance
 * Graphical or textual reports of all natural persons’ data
 * Real-time reports of all areas with natural person records
 * Data Privacy Impact Accessment (DPIA Management)
 * Data breach Analysis and Reports
 * Custom Forms and Dashboards
 * Can be deployed as a cloud native platform as a service self-hosted solution and/or on-prem.

## Architecture (Modules)

The Pontus Vision platform solves data mapping and management of personal data challenges in 3 modules:

![](images-README/arch-components.png)


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

Pontus Vision is based on the POLE (Person, Object, Location, Event) data model to Track data. This is a model used by the UK Government to associate data with individuals. The POLE model creates relationships between People, Objects, Locations and Events, forming the basis of a robust intelligence structure.
</details>

### COMPLY

Gathers links to all personal data within an organization, with graphical or textual reports, using a scoring system based on the ICO’s 12 steps to GDPR compliance.
<details>

All data is consolidated in a dashboard, for graphical or textual visualization.

The solution gathers links to all personal data within an organization, with graphical or textual reports, using a scoring system based on the ICO’s 12 steps to GDPR compliance.

All forms and reports are managed in real time, showing the areas of the organization that have personal data.
</details>

<br/>

# Pre-requisites
 - Linux Ubuntu 20.04
   - ensure that all packages are up to date
   - ensure that the `git` client is installed 
 - 8-core CPU            
 - 32GB RAM
 - 250GB Disk

## Architecture (Components)
All Pontus Vision components have been created as docker containers; the following table summarises the key components:


| Docker image                                         |Module   | Description                                     | Stateful            | Image Size | Min Memory |
|------------------------------------------------------|---------|-------------------------------------------------|---------------------|------------|------------|
|  pontusvisiongdpr/grafana-pt                         |Comply   | Dashboard - historical KPIs and data tables     | Yes                 | 142.2MB    | 39MiB      |
|  pontusvisiongdpr/pontus-comply-nginx-lgpd:light     |Comply   | (optional) API Gateway                          | No                  | 64MB       | 6MiB       |
|  pontusvisiongdpr/pontus-comply-keycloak:latest      |Comply   | (optional) Authenticator - creates JWT token    | Yes                 | 404MB      | 492MiB     |
|  pontusvisiongdpr/pontus-track-graphdb-odb-pt:latest |Track    | Graph Database to store data in the POLE model  | Yes                 | 1.03GB     | 4.5GiB     |
|  pontusvisiongdpr/timescaledb:latest                 |Track    | Historical time series database                 | Yes                 | 73MB       | 192MiB     |
|  pontusvisiongdpr/postgrest:latest                   |Track    | REST API front end to timescale db              | No                  | 43MB       | 13MiB      |
|  pontusvisiongdpr/pontus-extract-spacy:latest        |Extract  | (optional) Natural language processor           | No                  | 4.12GB     | 105MiB     |
|  pontusvisiongdpr/pv-extract-tika-server-lambda      |Extract  | Extraction of text from documents               | No                  | 436.2MB    | 255MiB     |
|  pontusvisiongdpr/pv-extract-wrapper:latest          |Extract  | Extract modules to get data from (Un)structured sources  | No                  | 223.84 MB  |      ??????    |   

cronjobs

<br/>

# Installation

The easiest way to deploy the Pontus Vision platform locally is to start a docker desktop local kubernetes cluster, and follow the instructions below:

**<details><summary>Docker 🐳</summary>**

<details><summary>Windows Instructions</summary>

 * [Install Windows WSL2 Ubuntu 20.04](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
 * [Install Windows Docker desktop](https://docs.docker.com/docker-for-windows/install/) 
 * Enable Kubernetes on Docker Desktop:
   * Use WSL Engine: ![](images-README/windows-docker-desktop-settings.jpg)
   * Enable WSL2 Integration: ![](images-README/windows-docker-desktop-wsl-integration.jpg)
   * Enable Kubernetes: ![](images-README/windows-docker-desktop-kubernetes.jpg)

</details> 

<details><summary>MacOS Instructions</summary>
  
 * [Install MacOS Docker Desktop](https://docs.docker.com/docker-for-mac/install/)
 * Enable Kubernetes: ![](images-README/macos-dockerd-k8s.jpg)
 
</details>

<details><summary>Linux Instructions (Ubuntu 20.04)</summary>
  
 * [Install Docker](https://docs.docker.com/engine/install/ubuntu/)
 * [Install Kubernetes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
 * here are instructions from scratch:
```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cat  <<EOF > /tmp/kubeadm-config.yaml
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2  // k8s OR k3s
kubernetesVersion: v1.22.2
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1  //k8s SHOULDNT be k3s
cgroupDriver: systemd
EOF
#  sudo kubeadm init --pod-network-cidr=

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo swapoff -a

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```
##### systemd cgroup driver:
  To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set
```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```
If you apply this change make sure to restart containerd again:
```
sudo systemctl restart containerd
```

##### Cluster creation:
```
sudo kubeadm init --config=/tmp/kubeadm-config.yaml
```
If all goes well, you should see something similar to this:
```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.xx.xx.xx:6443 --token xxxxx.yyyyyyyyyyyyyy \
        --discovery-token-ca-cert-hash sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  
```
If running on a single cluster, you may have to run the following commands (to enable the master node and to add a network:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f  https://docs.projectcalico.org/manifests/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-

```

</details>

</details>

**<details><summary>OS package manager</summary>**
Before the `k3s` installation, remove `Snap` package manager, as it consumes too much CPU on small servers; this can be done by running the following:

```bash
 export SNAP_LIST=$(snap list)
 sudo ls
```

**run the loops below twice; this is NOT A TYPO:**

```bash
for i in ${SNAP_LIST}; do
  sudo snap remove --purge package-name
done

for i in ${SNAP_LIST}; do
  sudo snap remove --purge package-name
done

sudo rm -rf /var/cache/snapd/

sudo apt autoremove --purge snapd gnome-software-plugin-snap

rm -fr ~/snap
sudo apt-mark hold snapd
Update the server:

sudo apt update
sudo apt upgrade -y
sudo apt install git
```

</details>

**<details><summary>Lightweight Kubernetes (k3s) installation</summary>**

K3s - Lightweight Kubernetes. Easy to install, half the memory, all in a binary of less than 100 MB. For more info follow the [link](https://github.com/k3s-io/k3s/blob/master/README.md).

```bash
mkdir -p ~/work/client/
cd ~/work/client/
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```

Finally add this to the end of the .bashrc file:

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

</details>

**<details><summary>HELM installation</summary>**

HELM is a tool that streamlines installing and managing Kubernetes applications. To install it, run the following code:

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

</details>

**<details><summary>Pontus Vision Solution installation</summary>**
The helm chart used to configure the Pontus Vision platform exists in this repository.  To get it, clone this repository as follows:

for GDPR Demo:
```bash
git clone https://github.com/pontus-vision/pontus-vision.git
cd pontus-vision/k3s
```

for LGPD Demo:
```bash
git clone https://github.com/pontus-vision/pontus-vision.git
cd pontus-vision/k3s-pt
```

Also create the cert-manager namespace and install cert manager:
```
kubectl create namespace cert-manager
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.6.1 \
  --set installCRDs=true
```

Go to the k3s folder (the same directory as this README.md file)

**Edit the secret Files structure**

Please create a directory structure similar to the following:

```
k3s(-pt)/secrets/          
├── env                           
│   ├── pontus-grafana            
│   │   └── GF_PATHS_CONFIG       
│   ├── pontus-graphdb            
│   │   └── ORIENTDB_ROOT_PASSWORD
│   ├── pontus-postgrest          
│   │   ├── PGRST_DB_ANON_ROLE    
│   │   └── PGRST_DB_URI          
│   └── pontus-timescaledb        
│       ├── POSTGRES_PASSWORD     
│       └── POSTGRES_USER         
├── CRM-api-key               
├── CRM-json                  
├── ERP-api-key              
├── microsoft-json               
└── google-json                    
```

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

<details><summary>CRM-api-key</summary>

This token is used to grant access to CRM's data. For more information on how to get this value, please contact DPO.

**Format**: one-line text.

</details>


<details><summary>CRM-json</summary>

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

<details><summary>ERP-api-key</summary>

This token is used to grant access to ERP's data. For more information on how to get this value, please contact IT.

**Format**: one-line text.

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

Here's the instructions on how to get those credentials.

#### Azure API keys instructions:

![alt text](/images-README/azure-1.jpg)
![alt text](/images-README/azure-2.jpg)
![alt text](/images-README/azure-3.jpg)
![alt text](/images-README/azure-4.jpg)
![alt text](/images-README/azure-5.jpg)


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

</details>

**<details><summary>Configure the helm values</summary>**

The values files `pontus-vision/k3s(-pt)/helm/values-prod.yaml` and `pontus-vision/k3s(-pt)/helm/values-test.yaml` have configuration details that vary from environment to environment.  Here's an example:

```yaml
# Default values for pv-lgpd.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

pvvals:
  imageVers:
    graphdb: 1.13.21
  storagePath: "~/storage" # make sure to pass the exact path (Create persistent volumes storage section)
  hostname: "<hostname>"
  ErpUrlPrefix: "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # to get the keycloak public key, do an HTTP GET to the following URL: https://<hostname>/auth/realms/pontus
  keycloakPubKey: "******************************************"
```
</details>

**<details><summary>Create persistent volumes storage</summary>**

This step is important to ensure k3s data is kept by using **persistent volumes**.  To do so, please create a directory structure similar to the following:

```
~/storage                         
├── extract                       
│   ├── email                     
│   ├── CRM                   
│   ├── ERP                  
|   ├── microsoft
|   |   ├── data-breaches
|   |   ├── dsar
|   |   ├── fontes-de-dados
|   |   ├── legal-actions
|   |   └── mapeamentos
|   └── google
|       ├── meetings
|       ├── policies
|       ├── privacy-docs
|       ├── privacy-notice
|       ├── risk
|       ├── risk-mitigations
|       └── treinamentos
├── db                       
├── grafana                       
├── keycloak                      
└── timescaledb                   
```

Make sure that the value for the `storagePath` key @ `pontus-vision/k3s(-pt)/helm/values-prod.yaml` and `pontus-vision/k3s(-pt)/helm/values-test.yaml` is the root of the directory structure above.	
Here is a set of commands that can create this structure if the value of `storagePath` is set to `~/storage`:
	
```bash
mkdir ~/storage
cd ~/storage
mkdir -p extract/email \
	extract/CRM \
	extract/ERP \
  	microsoft/data-breaches \
  	microsoft/dsar \
  	microsoft/fontes-de-dados \
  	microsoft/legal-actions \
  	microsoft/mapeamentos \
  	google/meetings \
  	google/policies \
  	google/privacy-docs \
  	google/privacy-notice \
  	google/risk \
  	google/risk-mitigations \
  	google/treinamentos \
	db \
	grafana \
	keycloak \
	timescaledb
```	


</details>

<br/>

# Management


**Accessing Grafana (Pontus Vision Dashboard)**

1. point a browser to [http://localhost($HOSTNAME)/pv](http://localhost($HOSTNAME)/pv)
2. Use the user name `lmartins@pontusnetworks.com` and the default password `pa55word`

## Start

**<details><summary>Start whole environment</summary>**

Run the start-env-xxx.sh script:

```
./start-env-prod.sh
```
or 
```
./start-env-test.sh
```
</details>

**<details><summary>Start GraphDB</summary>**

Run the start-graph-xxx.sh script:

```
./start-graph-prod.sh
```
or

```
./start-graph-test.sh
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

Pontus Vision is constantly upgrading and updating its container images to keep up with the latest tech and security patches. To change versions simply change the `imageVers` value @ `pontus-vision/k3s(-pt)/helm/values-prod.yaml` and `pontus-vision/k3s(-pt)/helm/values-test.yaml` then restart k3s env (look bellow @ **Restart k3s env** section).

**Json File**:

```yaml
pvvals:
  imageVers:
    graphdb: 1.13.21 #
    grafana: 1.13.2 #
    # container: M.m.p
    # etc.
  storagePath: "~/storage" # make sure to pass the exact path (Create persistent volumes storage section)
  hostname: "<hostname>"
  ErpUrlPrefix: "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # to get the keycloak public key, do an HTTP GET to the following URL: https1://<hostname>/auth/realms/pontus
  keycloakPubKey: "******************************************"
```

</details>

**<details><summary>Secrets</summary>**

To update any secrets or credentials, go to the `pontus-vision/k3s(-pt)/secrets` folder, update the relevant files, and run  `./start-env-prod.sh` to update the secrets's values.

</details>

**<details><summary>Restart k3s env</summary>**

#### Shutting down

To stop the whole environment, run the following command: 
```
./stop-env.sh 
```

#### Starting up

To start the whole environment, run the following command:

```
./start-env-prod.sh
```

</details>

<br/>

## Monitoring/Troubleshooting

**<details><summary>Listing k3s pods</summary>**

To do so type `$ kubectl get pods` then a tab table alike is displayed:


```
NAME                                                       READY   STATUS              RESTARTS   AGE  
svclb-pontus-grafana-t9m6w                                 1/1     Running             0          91m  
svclb-pontus-lgpd-2jx9g                                    1/1     Running             0          91m  
pontus-lgpd                                                1/1     Running             0          91m  
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

**Taints** allow a node to repel a set of pods, but this can prevent some pods from running. For more information click this [link](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)

If you get an **ERROR** like the one marked in the image, when running `$ kubectl describe pods <pod name>` : 

![alt text](/images-README/k3s-taint-1.png)

OR, when running `$ kubectl describe nodes <node name>` the **Taints** section is different than `<none>`:

![alt text](/images-README/k3s-taint-2.png)

Then copy the Taints that were shown for the specific node and run the following command to **untain** each one of them:

```
kubectl taint nodes <node name> [Taint]-
```

For example:

![alt text](/images-README/k3s-taint-3.png)

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

To be able to add/update/change users on Keycloak, one needs to login as a **Super User**. To do so, go to the following link => [https://$HOSTNAME/auth/](https://$HOSTNAME/auth/) and authenticate with admin default credential **username:admin/password:admin**.

Here's some screenshots steps on how to create a new user:

![alt text](/images-README/keycloak-a.png)

> When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

![alt text](/images-README/keycloak-b.png)

> Then click on **Proceed(Continue) to $HOSTNAME**.

![alt text](/images-README/keycloak-1.png)

> This is Keycloak's home page. Click on **Administration Console**.

![alt text](/images-README/keycloak-2.png)

> Enter the default credentials and click **Sign in**.

![alt text](/images-README/keycloak-c.png)

> At the main panel, locate **Users** under **Manage** on the left menu.

![alt text](/images-README/keycloak-3.png)

> On the far right, click **Add user**.

![alt text](/images-README/keycloak-5.png)

> Fill in the fields (the mandatory at least) \**ID is auto incremented*. You can also add **User actions**.

![alt text](/images-README/keycloak-6.png)

> Finally, click on **Save**.

</details>

**<details><summary>Grafana</summary>**

Grafana is a multi-platform open source analytics and interactive visualization web application. Connected with Pontus Vision's product, provides charts, graphs, and alerts on the web.

The same **Super User** privilege is needed here ...go to the main login page [https://$HOSTNAME/pv](https://$HOSTNAME/pv) and enter the admin credentials sent by your administrator.

Here's some screenshots steps on how to create a new user:

![alt text](/images-README/keycloak-a.png)

> When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

![alt text](/images-README/keycloak-b.png)

> Then click on **Proceed(Continue) to $HOSTNAME**.

![alt text](/images-README/grafana-1.png)

> Enter the admin credentials then click **Sign in**.

![alt text](/images-README/grafana-2.png)

> Grafana's main page is as shown. Locate the **Shield** icon (Server Admin), under it, click on **Users**.

![alt text](/images-README/grafana-3.png)

> A table containing all registered Uers wil appear. On the upper right corner, click on the blue **New user** button.

![alt text](/images-README/grafana-4.png)

> Fill in the fields (mandatory at least), then click the blue **Create user** button.

![alt text](/images-README/grafana-5.png)

> By clicking on the newly created user you can edit its Information, Permissions, Organisations it belongs and open Sessions.

![alt text](/images-README/grafana-6.png)

> To change a User's role in an Organisation, click on **Change role** *(Under Organisations)*, choose the role from the drop-down menu, then click **Save**.

</details>

<br/>

## password reset

**<details><summary>Instructions</summary>**

To reset a user's password, one only needs to change it using Keycloak single sign-on and access management. Go to the following link => [https://$HOSTNAME/auth/](https://$HOSTNAME/auth/) and authenticate with admin default credential **username:admin/password:admin**.

Here's some screenshots steps on how to reset a user's password:

![alt text](/images-README/keycloak-a.png)

> When you access the link for the first time, the browser will warn that the connection isn't private, just ignore it and click on **Advanced**.

![alt text](/images-README/keycloak-b.png)

> Then click on **Proceed(Continue) to $HOSTNAME**.

![alt text](/images-README/keycloak-1.png)

> This is Keycloak's home page. Click on **Administration Console**.

![alt text](/images-README/keycloak-2.png)

> Enter the default credentials and click **Sign in**.

![alt text](/images-README/keycloak-c.png)

> At the main panel, locate **Users** under **Manage** on the left menu.

![alt text](/images-README/keycloak-4.png)

> Click on **View all users** next to the search bar. Then a table containing all registered users will show. On the **Actions** column click on **Edit**.

![alt text](/images-README/pass-reset-1.png)

> Change the upper tab to **Credentials**. Then under **Reset Password** type the new password.

![alt text](/images-README/pass-reset-2.png)

> You can toggle the **Temporary** button, to force the user to change the password once he logs in for the first time.

![alt text](/images-README/pass-reset-3.png)

> Then click the **Reset Password** button. A popup will show to confirm the change. Click the red **Reset password** button.

![alt text](/images-README/pass-reset-4.png)

> After loading, the page will reload and a green popup will appear with the message **Success**.

</details>
