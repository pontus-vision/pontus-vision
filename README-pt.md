
# Pontus Vision Brasil

  [Pontus Vision](https://www.pontusvision.com.br) é uma plataforma de código aberto para mapeamento de dados e gerenciamento de dados pessoais. Ele ajuda as empresas a cumprir os regulamentos de proteção de dados, como **CCPA** da Califórnia (EUA), **LGPD** do Brasil e **GDPR** da União Europeia.

<br/>

## Porque PontusVision

Pontus Vision tem os seguintes benefícios:

  * Extração de dados não estruturados e estruturados
  * Painel de conformidade com as 12 etapas da ICO (Information Commissioner's Office do REino Unido)
  * Gerenciamento de consentimento, incluindo APIs para garantir compliance
  * Relatórios gráficos ou textuais de todos os dados de pessoas físicas
  * Relatórios em tempo real de todas as áreas com cadastro de pessoa física
  * Acesso ao Relatório de Impacto à Proteção de Dados Pessoais (RIPD)
  * Análise e relatórios de violação de dados
  * Formulários e painéis personalizados
  * Pode ser implantado no local/nuvem (auto-hospedado) ou usado como SaaS

<br/>

## Arquitetura (Módulos)

  A plataforma Pontus Vision resolve os desafios de mapeamento de dados e gerenciamento de dados pessoais em 3 módulos:

  ![](images-README/arch-components.png)


### EXTRAIR (EXTRACT)

  Extrair Dados Pessoais Estruturados em Bancos de Dados, CRM, ERP e sistemas proprietários. Também funciona com dados não estruturados, como e-mails, PDFs, Word e Excel.

<details>

  A plataforma Pontus Vision extrai dados estruturados e não estruturados de forma automatizada e sem interferência nas operações diárias. A solução não requer alterações nos sistemas dos clientes, podendo receber grandes volumes de dados de diversos sistemas corporativos. Conectores para sistemas ainda não suportados podem ser facilmente implementados.

  Dados Estruturados: Bancos de dados, CRM, ERP e sistemas proprietários.
  Dados não estruturados: e-mails, documentos do Microsoft Office, arquivos PDF e outros.

</details>

### ACOMPANHAR (TRACK)

  Mapeia todos os dados do módulo _Extract_, identificando pessoas físicas com o mínimo de dados necessários, escalável para trilhões de registros.

  <details>

  Nossa solução mapeia dados rastreando todas as fontes de dados desde o estágio _Extract_, identificando os dados do cliente com o mínimo de informações possível, usando bancos de dados gráficos e tecnologias de processamento de linguagem natural, suportando trilhões de registros.

  A escalabilidade é extremamente importante, pois o número de dados sobre pessoas físicas cresce diariamente, com cada interação de cliente ou equipe gerando novos registros.

  A Pontus Vision é baseado no modelo de dados **POLE** (Pessoa, Objeto, Local, Evento) para rastrear dados. Este é um modelo usado pelo governo do Reino Unido para associar dados a indivíduos. O modelo POLE cria relações entre Pessoas, Objetos, Locais e Eventos, formando a base de uma estrutura de inteligência robusta.

  </details>

### CONFORMIDADE (COMPLY)

  Reúne links para todos os dados pessoais dentro de uma organização, com relatórios gráficos ou textuais, usando um sistema de pontuação baseado nas 12 etapas da ICO para conformidade com a LGPD.

  <details>

  Todos os dados são consolidados em um dashboard, para visualização gráfica ou textual.

  A solução reúne links para todos os dados pessoais de uma organização, com relatórios gráficos ou textuais, usando um sistema de pontuação baseado nas 12 etapas da ICO para conformidade com a LGPD.

  Todos os formulários e relatórios são gerenciados em tempo real, mostrando as áreas da organização que possuem dados pessoais.

</details>

<br/> 

## Arquitetura (Componentes)

  All Pontus Vision components have been created as docker containers; the following table summarises the key components:


  | Imagem Docker                                        |Módulo   | Descrição                                       | Mantém o estado (Stateful)            | Tamanho da imagem | Memória mínima  |
  |------------------------------------------------------|---------|-------------------------------------------------|---------------------|------------|------------|
  |  pontusvisiongdpr/grafana:1.13.2                     |Comply   | Painel - KPIs históricos e tabelas de dados     | Sim                 | 140.67MB   | 39MiB      |
  |  pontusvisiongdpr/pontus-comply-keycloak:latest      |Comply   | (opcional) Autenticador - cria o token JWT    | Sim                 | 404MB      | 492MiB     |
  |  pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.12    |Track    | Banco de dados gráfico para armazenar dados no modelo POLE  | Sim                 | 1.04GB     | 4.5GiB     |
  |  pontusvisiongdpr/timescaledb:latest                 |Track    | Banco de dados de séries temporais                 | Sim                 | 73MB       | 192MiB     |
  |  pontusvisiongdpr/postgrest:latest                   |Track    | Front-end da API REST para timescaledb             | Não                  | 43MB       | 13MiB      |
  |  pontusvisiongdpr/pontus-extract-spacy:1.13.2        |Extract  | (opcional) Processador de linguagem natural           | Não                  | 4.12GB     | 105MiB     |
  |  pontusvisiongdpr/pv-extract-tika-server-lambda:1.13.2     |Extract  | Extração de texto de documentos               | Não                  | 436.2MB    | 255MiB     |
  |  pontusvisiongdpr/pv-extract-wrapper:1.13.2          |Extract  | Extrai módulos para obter dados de fontes (não)estruturadas. Cada fonte de dado exigi uma instância diferente  | Não                  | 223.84 MB  |      23MiB    |

<br/>

# Pré-requisitos

  - Linux Ubuntu 20.04
    - garanta que todos os pacotes estejam atualizados
    - certifique-se de que o cliente `git` esteja instalado
  - Processador de 8 núcleos            
  - 32GB de RAM
  - Disco de 250 GB + espaço para os dados ingeridos (~1KB/registro)

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

**<details><summary>Removendo Snap (opcional - não necessário para WSL)</summary>**

  Antes da instalação do `k3s`, remova o gerenciador de pacotes `Snap`, pois ele consome muita CPU em servidores pequenos; isso pode ser feito executando os seguintes comandos:

  ```bash
  export SNAP_LIST=$(snap list)
  sudo ls
  ```

**execute os loops abaixo duas vezes; isso NÃO é um erro de digitação:**

  ```bash
  for i in ${SNAP_LIST}; do
    sudo snap remove --purge $i
  done

  for i in ${SNAP_LIST}; do
    sudo snap remove --purge $i
  done

  sudo rm -rf /var/cache/snapd/

  sudo apt autoremove --purge snapd gnome-software-plugin-snap

  rm -fr ~/snap
  sudo apt-mark hold snapd

  #Update the server:
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git curl ubuntu-server python3-pip
  sudo pip3 install yq
  ```

</details>

**<details><summary>Instalação da distribuição leve do Kubernetes (k3s)</summary>**

  K3s é um Kubernetes leve, fácil de instalar e usa menos recursos que o k8s. Para mais informações, siga o [link](https://github.com/k3s-io/k3s/blob/master/README.md).

  ```bash
  mkdir -p ~/work/client/
  cd ~/work/client/
  curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
  ```

  Observação: ao usar o WSL, a seguinte mensagem de erro aparecerá, mas pode ser ignorada:
  
   > System has not been booted with systemd as init system (PID 1). Can't operate. <br/>
   > Failed to connect to bus: Host is down

  Por fim, adicione isso ao final do arquivo `.bashrc`:

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

  Execute o arquivo .bashrc no contexto atual para aplicar as alterações:
  ```
  . ~/.bashrc
  ```

</details>

**<details><summary>Instalaçaõ do HELM</summary>**

  O HELM é uma ferramenta que simplifica a instalação e o gerenciamento de aplicativos Kubernetes. Para instalá-lo, execute o seguinte código:

  ```bash
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  ```

</details>

**<details><summary>Instalação do _Certificate Manager_</summary>**

  Depois de instalar o helm, crie o namespace _cert-manager_ e instale o _cert manager_; isso permitirá que os certificados https sejam gerenciados:
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

# Instalação

  A maneira mais fácil de implantar a plataforma Pontus Vision é executando uma VM ou Ubuntu 20.04 SO _bare-metal_ e seguir as instruções abaixo:

**<details><summary>Instalação da solução Pontus Vision</summary>**

  O _helm chart_ usado para configurar a plataforma Pontus Vision existe neste repositório. Clone este repositório e utilize a Demo GDPR ou LGPD:

  ```bash
  git clone https://github.com/pontus-vision/pontus-vision.git
  cd pontus-vision/k3s
  ```

## Arquivos Secret

  Esta demonstração usa _secrets_ do Kubernetes para armazenar várias senhas e credenciais confidenciais. Você precisará criar os seus próprios, mas para facilitar, criamos um arquivo `tar` com formatos de exemplo.

  Para baixar e extrair os _secrets_ de exemplo, execute o seguinte comando:
  ```
  ./download-sample-secrets.sh
  ```
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

**Modifique a estrutura de arquivos da pasta */secrets***

  Isso deve produzir uma estrutura de diretórios semelhante à abaixo. _secrets_ localizados dentro da pasta `env/` só devem ser modificados por usuários experientes; adicione seus outros _secrets_ à pasta `secrets/`.

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

  Este token é usado para conceder acesso aos dados do CRM. Para obter mais informações sobre como obter esse valor, entre em contato com o DPO.

  **Formato**: texto de uma linha.

</details>

<details><summary>crm-json</summary>

  Este json contém a chave de usuário do CRM. Para obter mais informações sobre como obter esse valor, entre em contato com o DPO.

  **Formato json:**

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

  **Descrição:**

  Caminho para o arquivo de configuração do grafana.

  **Valor Padrão:** 
  ```
  /etc/grafana/grafana-pontus.ini
  ```

</details>

<details><summary>env/pontus-graphdb/ORIENTDB_ROOT_PASSWORD</summary>

  **Descrição:**
    
  Arquivo de senha mestra para o orientdb.

  **Valor Padrão:**
  ```
  admin
  ```

</details>

<details><summary> env/pontus-postgrest/PGRST_DB_ANON_ROLE </summary>

  **Descrição:**
    
  Função (*role*) usada para conectar do postgrest ao postgres (usado para armazenar dados de séries temporais [*time series data*]).

  **Valor Padrão:**
  ```
  postgres
  ```

</details>

<details><summary> env/pontus-postgrest/PGRST_DB_URI</summary>

  **Descrição:**
    
  URI usado para o Postgrest falar com o TimescaleDB. Certifique-se de que a senha corresponda a env/pontus-timescaledb/POSTGRES_PASSWORD.

  **Valor Padrão:**
  ```
  postgres://postgres:mysecretpassword@pontus-timescaledb:5432/dtm
  ```

</details>

<details><summary> env/pontus-timescaledb/POSTGRES_PASSWORD</summary>

  **Descrição:**
    
  Senha de administrador do TimescaleDB.

  **Valor Padrão:**
  ```
  mysecretpassword
  ```

</details>

<details><summary> env/pontus-timescaledb/POSTGRES_USER</summary>

  **Descrição:**
    
  Nome de usuário do administrador do TimescaleDB.

  **Valor Padrão:**
  ```
  postgres
  ```

</details>

<details><summary>erp-api-key</summary>

  Este token é usado para conceder acesso aos dados do ERP. Para obter mais informações sobre como obter esse valor, entre em contato com o seu departamento de TI.

  **Formato**: texto de uma linha.

</details>

<details><summary>google-json</summary>

  Este json contém os _secrets_ do Google para conexão. Para obter mais informações sobre como obter esses valores, entre em contato com o seu departamento de TI.

  **Formato json:**

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

  Este json contém credenciais para acessar a conta da Microsoft da empresa e seus dados armazenados.

  **Formato json:**

  ```json
  {
    "clientId": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "clientSecret": "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
    "tenantId": "zzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
  }
  ```

  Aqui estão as instruções sobre como obter as credenciais do Azure.

#### Chaves de API do Azure - Instruções (*Em inglês*):

<!-- add .pdf version -->

  ![alt text](/images-README/azure-1.jpg)
  ![alt text](/images-README/azure-2.jpg)
  ![alt text](/images-README/azure-3.jpg)
  ![alt text](/images-README/azure-4.jpg)
  ![alt text](/images-README/azure-5.jpg)

</details>

</details>

**<details><summary>Configurando os _helm values_</summary>**

  Os arquivos _values_ `pontus-vision/k3s/helm/values-gdpr.yaml` e `pontus-vision/k3s/helm/values-lgpd.yaml` têm detalhes de configuração que variam de ambiente para ambiente. Aqui está um exemplo:

  ```yaml
  # Valores padrão para pv/.
  # Este é um arquivo formatado em YAML.

  pvvals:
    imageVers:
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.12"
      grafana: "pontusvisiongdpr/grafana:1.13.2"
    storagePath: "<adicione o path aqui>" # certifique-se de passar o caminho exato [seção Criar armazenamento de volumes persistentes (*persistent volumes*)]
    hostname: "<adicione o hostname aqui>"
    # para obter a chave pública do keycloak <keycloakPubKey>, faça um HTTP GET para a seguinte URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "******************************************"
  ```

## `cd pv/templates` para configurar os **cronjobs**.

  <!--
  TODO templates cronjob documentation
  -->

<br/>

</details>

**<details><summary>Criar armazenamento de volumes persistentes (*persistent volumes*)</summary>**

  Esta etapa é importante para garantir que os dados do k3s sejam mantidos usando **volumes persistentes**. Para fazer isso, crie uma estrutura de diretórios semelhante à seguinte:

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

  Certifique-se de que o valor da chave `storagePath` em `pontus-vision/k3s/helm/values-gdpr.yaml` e `pontus-vision/k3s/helm/values-lgpd.yaml` é a raiz da estrutura de diretórios acima.
  	
  Aqui está um conjunto de comandos que podem criar essa estrutura se o valor de `.Values.pvvals.storagePath` for definido como `~/storage`:
    
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

Somente quando configurados os passos anteriores, volte para a pasta `pontus-vision/k3s` para rodar a Demo.

Execute o seguinte para iniciar a demonstração do GDPR:

```bash
./start-env-gdpr.sh
# Observação: O comando acima pode falhar na primeira vez, pois o k3s estará baixando imagens grandes e pode atingir o tempo limite.
```

Ou... Execute o seguinte para iniciar a demonstração da LGPD:

```bash
./start-env-lgpd.sh
# Observação: O comando acima pode falhar na primeira vez, pois o k3s estará baixando imagens grandes e pode atingir o tempo limite.
```

<br/>

# Gerenciamento

**Acessando o Grafana (Dashboard Pontus Vision)**

  1. Aponte um navegador para [https://localhost/pv](https://localhost/pv)
  2. Use o nome de usuário `lmartins@pontusnetworks.com` e a senha padrão `pa55word`

<br/>

## Iniciar

**<details><summary>Iniciar todos os pods do ambiente</summary>**

  Execute o script start-env-xxx.sh:

  ```bash
  ./start-env-gdpr.sh # GDPR Demo
  ```

  ou

  ```bash
  ./start-env-lgpd.sh # LGPD Demo
  ```

</details>

**<details><summary>Iniciar o GraphDB</summary>**

  Execute o script start-graph-xxx.sh:

  ```bash
  ./start-graph-gdpr.sh # GDPR Demo
  ```

  ou

  ```bash 
  ./start-graph-lgpd.sh # LGPD Demo
  ```

</details>

<br/>

## Atualizações

  <!-- ### PV cronjob container's Versions

  Make sure to always have the `:latest` container cronjob running, copy the below to `crontab -e`:

  ```
  00 00 * * * git pull
  00 01 * * * env -i helm tamplate
  ```  
  -->

**<details><summary>Pontus Vision imageVers</summary>**

  A Pontus Vision está constantemente melhorando e atualizando suas imagens de contêiner para acompanhar as últimas atualizações de tecnologia e segurança. Para alterar as versões, basta alterar o valor `pvvals.imageVers` em `pontus-vision/k3s/helm/values-gdpr.yaml` e `pontus-vision/k3s/helm/values-lgpd.yaml` e reiniciar o k3s env (veja abaixo a seção **Reiniciar o ambiente k3s**).

  **Arquivo json**:

  ```yaml
  pvvals:
    imageVers:
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.12"
      grafana: "pontusvisiongdpr/grafana:1.13.2"
      # container: M.m.p
      # etc.
    storagePath: "<adicione o path aqui>" # certifique-se de passar o caminho exato [seção Criar armazenamento de volumes persistentes (*persistent volumes*)]
    hostname: "<adicione o hostname aqui>"
    ErpUrlPrefix: "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    # para obter a chave pública do keycloak <keycloakPubKey>, faça um HTTP GET para a seguinte URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "******************************************"  
  ```

</details>

**<details><summary>Secrets</summary>**

  Para atualizar quaisquer _secrets_ ou credenciais, vá para a pasta `pontus-vision/k3s/secrets`, atualize os arquivos relevantes e reinicie o k3s env (veja abaixo na seção **Reiniciar o ambiente k3s**) para atualizar os valores dos _secrets_.

</details>

**<details><summary>Reiniciar o ambiente k3s</summary>** 

#### Encerrando o k3s

  Para parar todo o ambiente, execute o seguinte comando:
  ```
  ./stop-env.sh 
  ```

#### Inicialização do k3s

  Para iniciar todo o ambiente, execute o seguinte comando:

  Para a Demo GDPR:
  ```
  ./start-env-gdpr.sh
  ```

  Para a Demo LGPD:
  ```
  ./start-env-lgpd.sh
  ```

</details>

<br/>

## Monitoramento / Solução de Problemas

**<details><summary>Listando os pods do k3s</summary>**

  Para fazer isso, digite `$ kubectl get pods` e uma tabela de guias semelhante será exibida:

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

**<details><summary>logs do k3s</summary>**

  Para obter o log de um pod específico, execute:

  ```
  kubectl logs [-f] <NAME> [--tail]
  ```

  Para acompanhar o log, use a *flag* `-f`. E para mostrar os logs mais recentes use a *flag* `--tail` passando um número. Por exemplo:

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

 **Taints** permitem um nó repelir um conjunto de pods, mas isso pode impedir que alguns pods sejam executados. Para mais informações clique neste [link](https://kubernetes.io/pt-br/docs/concepts/scheduling-eviction/taint-and-toleration/).

  Se você receber um **ERRO** como o marcado na imagem, ao executar `$ kubectl describe pods <pod name>`:

  ![alt text](/images-README/k3s-taint-1.png)

  OU, ao executar `$ kubectl describe nodes <node name>` a seção **Taints** é diferente de `<none>`:

  ![alt text](/images-README/k3s-taint-2.png)

  Então, copie os Taints que foram mostrados para o nó específico e execute o seguinte comando para **untain** cada um deles:

  ```
  kubectl taint nodes <node name> [Taint]-
  ```

  Por exemplo:

  ![alt text](/images-README/k3s-taint-3.png)

</details>

**<details><summary>$ top</summary>**

  Para exibir os processos do Linux use o comando `top`. Em seguida, pressione o número `1` para ativar a visão de cada núcleo da CPU, algo parecido irá aparecer:

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
  Preste atenção no `wa` (Tempo gasto na espera de I/O), quanto menor, melhor!
  <!-- **hi** - Time spent handling hardware interrupt routines. (Whenever a peripheral unit want attention form the CPU, it literally pulls a line, to signal the CPU to service it)
**si** - Time spent handling software interrupt routines. (a piece of code, calls an interrupt routine...)
**st** - Time spent on involuntary waits by virtual cpu while hypervisor is servicing another processor (stolen from a virtual machine) -->

</details>

<br/>

## Criação de Usuários

**<details><summary>Keycloak</summary>**

  O Keycloak é um software *open source* usado com as soluções Pontus Vision para permitir logon único, permitindo gerenciamento de identidade e acesso.

  Para poder adicionar/atualizar/alterar usuários no Keycloak, é necessário fazer login como **Superusuário**. Para fazer isso, acesse o link a seguir => [https://\<adicione-o-hostname-aqui\>/auth/](https://$\<adicione-o-hostname-aqui\>/auth/) e autentique-se com a credencial padrão do administrador **nome de usuário: admin / senha: admin**.

  Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

  ![alt text](/images-README/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![alt text](/images-README/keycloak-b.png)

  > Depois clique em **Proceed(Continue) to \<hostname\>**.

  ![alt text](/images-README/keycloak-1.png)

  > Esta é a página inicial do Keycloak. Clique em **Administration Console**.

  ![alt text](/images-README/keycloak-2.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![alt text](/images-README/keycloak-c.png)

  > No painel principal, localize **Users** em **Manage** no menu à esquerda.

  ![alt text](/images-README/keycloak-3.png)

  > Na parte direita, clique em **Add user**.

  ![alt text](/images-README/keycloak-5.png)

  > Preencha os campos (ao menos os campos obrigatórios) \**ID é incrementado automaticamente*. Você também pode adicionar **User actions**.

  ![alt text](/images-README/keycloak-6.png)

  > Por fim, clique em **Save**.

</details>

**<details><summary>Grafana</summary>**

  O Grafana é um aplicativo *open source* web multiplataforma de análise e visualização interativa. Conectado aos produtos da Pontus Vision, fornece tabelas, gráficos e alertas na web.

  O mesmo privilégio de **Superusuário** é necessário aqui... vá para a página de login principal [https://\<adicione-o-hostname-aqui\>/pv](https://\<adicione-o-hostname-aqui\>/pv) e insira as credenciais admin enviadas por seu administrador.

  Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

  ![alt text](/images-README/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![alt text](/images-README/keycloak-b.png)

  > Depois clique em **Proceed(Continue) to \<hostname\>**.

  ![alt text](/images-README/grafana-1.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![alt text](/images-README/grafana-2.png)

  > Esta é a página principal do Grafana. Localize o ícone **Escudo** (Server Admin), dentro dele, clique em **Users**.

  ![alt text](/images-README/grafana-3.png)

  > Aparecerá uma tabela contendo todos os usuários cadastrados. No canto superior direito, clique no botão azul **New user**.

  ![alt text](/images-README/grafana-4.png)

  > Preencha os campos (ao menos os campos obrigatórios), depois clique no botão azul **Create user**.

  ![alt text](/images-README/grafana-5.png)

  > Ao clicar no usuário recém-criado você pode editar suas Informações, Permissões, Organizações a que pertence e abrir Sessões.

  ![alt text](/images-README/grafana-6.png)

  > Para alterar a função de um usuário em uma organização, clique em **Change role** (Em *Organisations*), escolha a função no menu suspenso e clique em **Save**.

</details>

<br/>

## Redefinição de senha

**<details><summary>Instruções</summary>**

  Para redefinir a senha de um usuário, basta alterá-la usando o logon único e o gerenciamento de acesso do Keycloak. Vá para o seguinte link => [https://\<adicione-o-hostname-aqui\>/auth/](https://\<adicione-o-hostname-aqui\>/auth/) e autentique-se com a credencial padrão do administrador **nome de usuário : admin / senha: admin**.

  Aqui estão algumas capturas de tela das etapas de como redefinir a senha de um usuário:

  ![alt text](/images-README/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![alt text](/images-README/keycloak-b.png)

  > Depois clique em **Proceed(Continue) to \<hostname\>**.

  ![alt text](/images-README/keycloak-1.png)

  > Esta é a página inicial do Keycloak. Clique em **Administration Console**.

  ![alt text](/images-README/keycloak-2.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![alt text](/images-README/keycloak-c.png)

  > No painel principal, localize **Users** em **Manage** no menu à esquerda.

  ![alt text](/images-README/keycloak-4.png)

  > Clique em **View all users** ao lado da barra de pesquisa. Em seguida, uma tabela contendo todos os usuários registrados será exibida. Na coluna **Actions**, clique em **Edit**.

  ![alt text](/images-README/pass-reset-1.png)

  > Altere a guia **Credentials**, na parte superior. Em seguida, em **Reset Password**, digite a nova senha.

  ![alt text](/images-README/pass-reset-2.png)

  > Você pode ativar o botão **Temporary**, para forçar o usuário a alterar a senha assim que fizer login pela primeira vez.

  ![alt text](/images-README/pass-reset-3.png)

  > Em seguida, clique no botão **Reset Password**. Um pop-up será exibido para confirmar a alteração. Clique no botão vermelho **Reset password**.

  ![alt text](/images-README/pass-reset-4.png)

  > Então a página será recarregada e um popup verde aparecerá com a mensagem **Success**.

</details>
