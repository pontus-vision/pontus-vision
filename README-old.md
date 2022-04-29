<!--
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

-->

-----------------------------------------------------------------------------------------------------------------

<!--
That should produce a directory structure similar to this:
```
secrets/
├── env
│   ├── pontus-grafana
│   │   └── GF_PATHS_CONFIG
│   ├── pontus-graphdb
│   │   ├── AWS_ACCESS_KEY_ID
│   │   ├── AWS_SECRET_ACCESS_KEY
│   │   └── ORIENTDB_ROOT_PASSWORD
│   ├── pontus-postgrest
│   │   ├── PGRST_DB_ANON_ROLE
│   │   └── PGRST_DB_URI
│   └── pontus-timescaledb
│       ├── POSTGRES_PASSWORD
│       └── POSTGRES_USER
├── google-creds-json
├── mapping-salesforce-graph
├── office-365-auth-client-id
├── office-365-auth-client-secret
├── office-365-auth-tenant-id
├── s3-creds
├── salesforce-client-id
├── salesforce-client-secret
├── salesforce-password
├── salesforce-username
├── watson-password
└── watson-user-name
```
### env/pontus-grafana/GF_PATHS_CONFIG
Path to the grafana configuration file
```
/etc/grafana/grafana-pontus.ini
```


### env/pontus-graphdb/AWS_ACCESS_KEY_ID
AWS ACCESS KEY Used to pull graphdb information from S3 buckets from the graph database

### env/pontus-graphdb/AWS_SECRET_ACCESS_KEY
AWS SECRET KEY Used to pull graphdb information from S3 buckets from the graph database

### env/pontus-graphdb/ORIENTDB_ROOT_PASSWORD
Master password file for orient db
```
admin
```

### env/pontus-postgrest/PGRST_DB_ANON_ROLE
Role used to connect from postgrest to postgres (used to store time series data)
```
postgres
```

### env/pontus-postgrest/PGRST_DB_URI
```
postgres://postgres:mysecretpassword@pontus-timescaledb:5432/dtm
```

### env/pontus-timescaledb/POSTGRES_PASSWORD
```
mysecretpassword
```

### env/pontus-timescaledb/POSTGRES_USER
```
postgres
```

### google-creds-json
This file has the credentials required for Google's NLP Engine

Here is a sample content:
```json
{ "type": "service_account", "project_id": "<PROJID_GOES_HERE>", "private_key_id": "<PRIV_KEY_ID_GOES_HERE>", "private_key": "-----BEGIN PRIVATE KEY-----\nPLEASE_ADD_YOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n", "client_email": "<some.email.com>", "client_id": "<CLIENT_ID_GOES_HERE>", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "token_uri": "https://accounts.google.com/o/oauth2/token", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/<ADD_YOUR_DETAILS_HERE>" }
```

### mapping-salesforce-graph
This file has the POLE mappings for Salesforce; note that this may also be added in-situ in the NiFi workflow, or stored in S3.
Here is a sample content:
```json
{ "updatereq": { "vertices": [ { "label": "Person.Natural", "props": [ { "name": "Person.Natural.Full_Name", "val": "${pg_FirstName?.toUpperCase()?.trim()} ${pg_LastName?.toUpperCase()?.trim()}", "predicate": "eq", "mandatoryInSearch": true }, { "name": "Person.Natural.Full_Name_fuzzy", "val": "${pg_FirstName?.toUpperCase()?.trim()} ${pg_LastName?.toUpperCase()?.trim()}", "excludeFromSearch": true }, { "name": "Person.Natural.Last_Name", "val": "${pg_LastName?.toUpperCase()?.trim()}", "excludeFromSubsequenceSearch": true }, { "name": "Person.Natural.Date_Of_Birth", "val": "${pg_Birthdate?:'1666-01-01'}", "type": "java.util.Date", "mandatoryInSearch": false, "excludeFromSubsequenceSearch": true }, { "name": "Person.Natural.Title", "val": "${pg_Salutation?:''}", "excludeFromSearch": true }, { "name": "Person.Natural.Nationality", "val": "${pg_MailingCountry?:'Unknown'}", "excludeFromSearch": true }, { "name": "Person.Natural.Customer_ID", "val": "${pg_Id}", "mandatoryInSearch": true }, { "name": "Person.Natural.Gender", "val": "Unknown", "mandatoryInSearch": false, "excludeFromSubsequenceSearch": true } ] }, { "label": "Location.Address", "props": [ { "name": "Location.Address.Full_Address", "val": "${ ( (pg_MailingStreet?:'')+ '\\\\n' + (pg_MailingCity?:'') + '\\\\n' + (pg_MailingState?:'') + '\\\\n' + (pg_MailingCountry?:'')).replaceAll('\\\\n', ' ') }", "mandatoryInSearch": true }, { "name": "Location.Address.parser", "val": "${ ( (pg_MailingStreet?:'')+ '\\\\n' + (pg_MailingCity?:'') + '\\\\n' + (pg_MailingState?:'') + '\\\\n' + (pg_MailingCountry?:'')).replaceAll('\\\\n', ' ') }", "excludeFromSearch": true, "type": "com.pontusvision.utils.LocationAddress" }, { "name": "Location.Address.Post_Code", "val": "${com.pontusvision.utils.PostCode.format(pg_MailingPostalCode)}", "excludeFromSearch": true } ] }, { "label": "Object.Email_Address", "props": [ { "name": "Object.Email_Address.Email", "val": "${pg_Email}", "mandatoryInSearch": true } ] }, { "label": "Object.Phone_Number", "props": [ { "name": "Object.Phone_Number.Raw", "val": "${pg_Phone}", "mandatoryInSearch": false }, { "name": "Object.Phone_Number.Type", "val": "Work", "excludeFromSubsequenceSearch": true }, { "name": "Object.Phone_Number.Numbers_Only", "val": "${(pg_Phone?.replaceAll('[^0-9]', '')?:'00000000')}", "excludeFromSearch": true, "type":"[Ljava.lang.String;" }, { "name": "Object.Phone_Number.Last_7_Digits", "val": "${(((pg_Phone?.replaceAll('[^0-9]', ''))?:'0000000')[-7..-1])}", "mandatoryInSearch": true, "type":"[Ljava.lang.String;" } ] }, { "label": "Object.Data_Source", "props": [ { "name": "Object.Data_Source.Name", "val": "salesforce.com", "mandatoryInSearch": true, "excludeFromUpdate": true } ] }, { "label": "Event.Group_Ingestion", "props": [ { "name": "Event.Group_Ingestion.Metadata_Start_Date", "val": "${pg_currDate}", "mandatoryInSearch": true, "excludeFromSearch": false, "type": "java.util.Date" }, { "name": "Event.Group_Ingestion.Metadata_End_Date", "val": "${new Date()}", "excludeFromSearch": true, "type": "java.util.Date" }, { "name": "Event.Group_Ingestion.Type", "val": "Marketing Email System", "excludeFromSearch": true }, { "name": "Event.Group_Ingestion.Operation", "val": "Structured Data Insertion", "excludeFromSearch": true } ] }, { "label": "Event.Ingestion", "props": [ { "name": "Event.Ingestion.Type", "val": "Marketing Email System", "excludeFromSearch": true }, { "name": "Event.Ingestion.Operation", "val": "Structured Data Insertion", "excludeFromSearch": true }, { "name": "Event.Ingestion.Domain_b64", "val": "${original_request?.bytes?.encodeBase64()?.toString()}", "excludeFromSearch": true }, { "name": "Event.Ingestion.Metadata_Create_Date", "val": "${new Date()}", "excludeFromSearch": true, "type": "java.util.Date" } ] } ], "edges": [ { "label": "Uses_Email", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Email_Address" }, { "label": "Has_Phone", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Home_Phone_Number" }, { "label": "Has_Phone", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Phone_Number" }, { "label": "Lives", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Location.Address" }, { "label": "Has_Policy", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Phone_Number" }, { "label": "Has_Ingestion_Event", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Event.Ingestion" }, { "label": "Has_Ingestion_Event", "fromVertexLabel": "Event.Group_Ingestion", "toVertexLabel": "Event.Ingestion" }, { "label": "Has_Ingestion_Event", "toVertexLabel": "Event.Group_Ingestion", "fromVertexLabel": "Object.Data_Source" } ] } }
```
### office-365-auth-client-id
This file has the Office 365 auth client id; the format is typically just a GUID.
Here is a sample content:
```
12345678-90ab-cdef-0123-456789abcdef
```

### office-365-auth-client-secret
This file has the Office 365 auth client secret; the format has randomly generated strings
Here is a sample content:
```
Aasdf888^%8>73321;;123k4k123k415k123
```
### office-365-auth-tenant-id
This file has the Office 365 auth tenant id; the format is typically just a GUID.
Here is a sample content:
```
87654321-90ab-cdef-0123-456789abcdef
```
### s3-creds
This file has the credentials to connect to AWS S3 Buckets
Here is a sample content:
```
aws_access_key = AKIAQQQQQQQQQQQQQQQQ
aws_secret_key = cccccccccccccccccccccccccccccccccccccccc
#assumed_role = True
#assumed_role_arn = arn:aws:iam::012345678901:role/orientdb-role
aws_access_key_id = AKIAQQQQQQQQQQQQQQQQ
aws_secret_access_key = cccccccccccccccccccccccccccccccccccccccc
accessKey=AKIAQQQQQQQQQQQQQQQQ
secretKey=cccccccccccccccccccccccccccccccccccccccc
```
### salesforce-client-id
This file has the Salesforce alphanumeric API client id
Here is a sample content:
```
00000000000000000000000000000000000.abcdefghijklmnopqrstuvwzyzABCDEFGHIJKLMNOPQRSTUVW
```
### salesforce-client-secret
This file has the Salesforce HEX API client secret
Here is a sample content:
```
01234567890DEADBEE01234567890DEADBEE01234567890DEADBEEFFF0123456
```
### salesforce-password
This file has the Salesforce API's alphanumeric password
Here is a sample content:
```
passwordpasswordpassword123456789
```
### salesforce-username
This file has the Salesforce API's user name (typically an e-mail address)
Here is a sample content:
```
my@email.com
```
### watson-password
This file has the IBM Watson API Password (typically an alpha-numeric random string)
Here is a sample content:
```
dfghjkl32j3
```

### watson-user-name
This file has the IBM Watson API User Name (typically a GUID)
Here is a sample content:
```
87654321-90ab-cdef-0123-456789abcdef
```
-->

-----------------------------------------------------------------------------------------------------------------

<!--
To do so, please create a directory structure similar to the following:
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
Check that the value for the `storagePath` key @ `pontus-vision/k3s/helm/custom-values.yaml` is the root of the directory structure above.
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
-->