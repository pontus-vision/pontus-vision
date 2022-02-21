
# Pontus Vision Brasil

[Pontus Vision](https://www.pontusvision.com.br) é uma plataforma de código aberto para mapeamento de dados e gerenciamento de dados pessoais. Ele ajuda as empresas a cumprir os regulamentos de proteção de dados, como **CCPA** (Califórnia - EUA), **LGPD** (Brasil) e **GDPR** (União Européia).

Para mais informações siga o [link](https://github.com/pontus-vision/pontus-vision/blob/main/README.md).

<br/>

# Pré requisitos
 - Linux Ubuntu 20.04
   - garanta que todos os pacotes estejam atualizados

   - verifique se o cliente `git` está instalado 
 - 8-core CPU            
 - 32GB RAM          

<br/>

# Instalação

**<details><summary>Gerenciador de pacotes SO</summary>**
Antes da instalação do `k3s`, remova o gerenciador de pacotes `Snap`, pois ele consome muita CPU em servidores pequenos; isso pode ser feito executando o seguinte fragmento de código:

```bash
 export SNAP_LIST=$(snap list)
 sudo ls
```

**execute os *loops* abaixo duas vezes; isso NÃO É UM ERRO DE DIGITAÇÃO:**

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

**<details><summary>Instalação da distribuição leve do Kubernetes (k3s)</summary>**

```bash
mkdir -p ~/work/client/
cd ~/work/client/
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```

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

</details>

**<details><summary>Instalaçaõ do HELM</summary>**

O HELM é uma ferramenta que simplifica a instalação e o gerenciamento de aplicativos Kubernetes. Para instalá-lo, execute o seguinte código:

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

</details>

**<details><summary>Instalação da solução LGPD da Pontus Vision</summary>**
O *helm chart* usado para configurar a plataforma LGPD Pontus Vision existe neste repositório. Para obtê-lo, clone este repositório da seguinte forma:

```
cd ~/work/client
git clone https://github.com/pontus-vision/pontus-vision.git
```

Para executar a plataforma Pontus Vision LGPD / GDPR no kubernetes, siga as instruções abaixo:

Vá para a pasta k3s (o mesmo diretório que este arquivo README.md)

**Modifique a estrutura de arquivos da pasta */secrets***

Crie uma estrutura de diretórios semelhante à seguinte:

```
k3s-extra-light/secrets/          
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

**Descrição:**

Caminho (*path*) para o arquivo de configuração do grafana.

**Valor padrão:** 
```
/etc/grafana/grafana-pontus.ini
```
</details>

<details><summary>env/pontus-graphdb/ORIENTDB_ROOT_PASSWORD</summary>

**Descrição:**
	
Arquivo de senha mestra para orient db.

**Valor padrão:**
```
admin
```
</details>

<details><summary> env/pontus-postgrest/PGRST_DB_ANON_ROLE </summary>

**Descrição:**
	
Função (*role*) usada para conectar do postgrest ao postgres (usado para armazenar dados de séries temporais [*time series data*]).

**Valor padrão:**
```
postgres
```
</details>

<details><summary> env/pontus-postgrest/PGRST_DB_URI</summary>

**Descrição:**
	
URI usado para o Postgrest se comunicar com o TimescaleDB. Certifique-se de que a senha corresponda a *env/pontus-timescaledb/POSTGRES_PASSWORD*.

**Valor padrão:**
```
postgres://postgres:mysecretpassword@pontus-timescaledb:5432/dtm
```
</details>

<details><summary> env/pontus-timescaledb/POSTGRES_PASSWORD</summary>

**Descrição:**
	
Senha admin do TimescaleDB.

**Valor padrão:**
```
mysecretpassword
```
</details>

<details><summary> env/pontus-timescaledb/POSTGRES_USER</summary>

**Descrição:**
	
Nome de usuário admin do TimescaleDB.

**Valor padrão:**
```
postgres
```

</details>

<details><summary>CRM-api-key</summary>

Este token é usado para conceder acesso aos dados da CRM. Para obter mais informações sobre como obter esse valor, entre em contato com o DPO.

**Formato**: texto de uma linha.

</details>


<details><summary>CRM-json</summary>

Este json contém a chave de usuário da CRM. Para obter mais informações sobre como obter esse valor, entre em contato com o DPO.

**Formato json:**

```json
{
  "secrets": {
    "CRM": {
      "User-Key": "**************************************************************"
    }
  }
}
```

</details>

<details><summary>ERP-api-key</summary>

Este token é utilizado para conceder acesso aos dados do ERP. Para obter mais informações sobre como obter esse valor, entre em contato com o TI.

**Formato**: texto de uma linha.

</details>

<details><summary>microsoft-json</summary>

Este json contém credenciais para acessar a conta do Microsoft da empresa e seus dados armazenados.

**Formato json:**

```json
{
  "clientId": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "clientSecret": "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
  "tenantId": "zzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
}
```

Aqui estão as instruções sobre como obter essas credenciais.

#### Chaves de API do Azure - Instruções (*Em inglês*):

![alt text](/images-README/azure-1.jpg)
![alt text](/images-README/azure-2.jpg)
![alt text](/images-README/azure-3.jpg)
![alt text](/images-README/azure-4.jpg)
![alt text](/images-README/azure-5.jpg)


</details>

<details><summary>google-json</summary>

Este json possui os *secrets* de conexão do Google. Para obter mais informações sobre como obter esses valores, entre em contato com a TI.

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

</details>

**<details><summary>Configuração dos *helm values*</summary>**

Os arquivos de valores `pontus-vision-k8s/k3s-extra-light/helm/values-prod.yaml` e `pontus-vision-k8s/k3s-extra-light/helm/values-test.yaml` têm detalhes de configuração que variam de ambiente para ambiente. Aqui está um exemplo:

```yaml
# Valores padrão para pv-lgpd.
# Este é um arquivo formatado em YAML.
# Declare variáveis a serem passadas em seus templates.

pvvals:
  imageVers:
    graphdb: 1.13.21
  storagePath: "~/storage" # certifique-se de passar o caminho exato (seção de armazenamento de volumes persistentes [*persistent volumes*])
  hostname: "<hostname>"
  ErpUrlPrefix: "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # para obter a chave pública do keycloak, faça um HTTP GET para a seguinte URL: https://<hostname>/auth/realms/pontus
  keycloakPubKey: "******************************************"
```
</details>

**<details><summary>Criar armazenamento de volumes persistentes (*persistent volumes*)</summary>**

Esta etapa é importante para garantir que os dados do k3s sejam mantidos usando **volumes persistentes**. Para fazer isso, crie uma estrutura de diretórios semelhante à seguinte:

```
~/storage                         
├── extract                       
│   ├── email                     
│   ├── CRM                   
│   ├── ERP                  
|   ├── microsoft
|	├── consents
|	|   ├── data-breaches
|	|   ├── dsar
|	|   ├── fontes-de-dados
|	|   ├── legal-actions
|	|   └── mapeamentos
|   └── google
|	    ├── meetings
|	    ├── policies
|	    ├── privacy-docs
|	    ├── privacy-notice
|	    ├── risk
|	    ├── risk-mitigations
|	    └── treinamentos
├── db                       
├── grafana                       
├── keycloak                      
└── timescaledb                   
```

Certifique-se de que o valor da chave `storagePath` em `pontus-vision-k8s/k3s-extra-light/helm/values-prod.yaml` e `pontus-vision-k8s/k3s-extra-light/helm/values -test.yaml` é a raiz da estrutura de diretórios acima.
Aqui está um conjunto de comandos que podem criar essa estrutura se o valor de `storagePath` for definido como `~/storage`:
	
```bash
mkdir ~/storage
cd ~/storage
mkdir -p extract/email \
	extract/CRM \
	extract/ERP \
	db \
	grafana \
	keycloak \
	timescaledb
```	

</details>

<br/>

# Gerenciamento

## Iniciar kubernetes

**<details><summary>Iniciar todos os pods do ambiente</summary>**

Execute o script start-env-xxx.sh:

```
./start-env-prod.sh
```
ou

```
./start-env-test.sh
```

</details>

**<details><summary>Iniciar o GraphDB</summary>**

Execute o script start-graph-xxx.sh:

```
./start-graph-prod.sh
```
ou

```
./start-graph-test.sh
```

</details>

<br/>

## Atualizações

**<details><summary>Pontus Vision imageVers</summary>**

A Pontus Vision está constantemente melhorando e atualizando suas imagens de contêiner para acompanhar as últimas atualizações de tecnologia e segurança. Para alterar as versões, basta alterar o valor `imageVers` em `pontus-vision-k8s/k3s-extra-light/helm/values-prod.yaml` e `pontus-vision-k8s/k3s-extra-light/helm/values-test.yaml` e reiniciar o k3s env (veja abaixo a seção **Reiniciar o k3s env**).

**Arquivo Json**:

```yaml
pvvals:
  imageVers:
    graphdb: 1.13.21 #
    grafana: 1.13.2 #
    # container: M.m.p
    # etc.
  storagePath: "~/storage" # certifique-se de passar o caminho exato (seção de armazenamento de volumes persistentes [*persistent volumes*])
  hostname: "<hostname>"
  ErpUrlPrefix: "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # para obter a chave pública do keycloak, faça um HTTP GET para a seguinte URL: https://<hostname>/auth/realms/pontus
  keycloakPubKey: "******************************************"
```

</details>

**<details><summary>Secrets</summary>**

Para atualizar quaisquer *secrets* ou credenciais, vá para a pasta `pontus-vision-k8s/k3s-extra-light/secrets`, atualize os arquivos relevantes e execute `./start-env-prod.sh` para atualizar os valores dos segredos.

</details>

**<details><summary>Reiniciar o k3s env</summary>**

#### Encerrando o k3s

Para parar todo o ambiente, execute o seguinte comando:

```
./stop-env.sh 
```

#### Inicialização do k3s

Para iniciar todo o ambiente, execute o seguinte comando:

```
./start-env-prod.sh
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

**Taints** permitem um nó repelir um conjunto de pods, mas isso pode impedir que alguns pods sejam executados. Para mais informações clique neste [link](https://kubernetes.io/pt-br/docs/concepts/scheduling-eviction/taint-and-toleration/)

Se você receber um **ERRO** como o marcado na imagem, ao executar `$ kubectl describe pods <pod name>` :

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
$ top (depois aperte 1)

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

Preste atenção no `wa` (Tempo gasto na espera de I/O), quanto menor, melhor!

</details>

<br/>

## Criação de Usuários

**<details><summary>Keycloak</summary>**

O Keycloak é um software *open source* usado com as soluções Pontus Vision para permitir logon único, permitindo gerenciamento de identidade e acesso.

Para poder adicionar/atualizar/alterar usuários no Keycloak, é necessário fazer login como **Superusuário**. Para isso, acesse o link a seguir => [https://$HOSTNAME/auth/](https://$HOSTNAME/auth/) e autentique-se com a credencial padrão admin: **username:admin/password:admin** .

Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

![alt text](/images-README/keycloak-a.png)

> Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

![alt text](/images-README/keycloak-b.png)

> Depois clique em **Proceed(Continue) to $HOSTNAME**.

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

O mesmo privilégio de **Superusuário** é necessário aqui... vá para a página de login principal [https://$HOSTNAME/pv](https://$HOSTNAME/pv) e insira as credenciais admin enviadas por seu administrador.

Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

![alt text](/images-README/keycloak-a.png)

> Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

![alt text](/images-README/keycloak-b.png)

> Depois clique em **Proceed(Continue) to $HOSTNAME**.

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

Para redefinir a senha de um usuário, basta alterá-la usando o Keycloak. Acesse o link a seguir => [https://$HOSTNAME/auth/](https://$HOSTNAME/auth/) e autentique-se com a credencial padrão admin: **username:admin/password:admin**.

Aqui estão algumas capturas de tela das etapas de como redefinir a senha de um usuário:

![alt text](/images-README/keycloak-a.png)

> Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

![alt text](/images-README/keycloak-b.png)

> Depois clique em **Proceed(Continue) to $HOSTNAME**.

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


------------------------------------------------------------------------- orig ---------------------------------------------------------------------------------------


# PontusVision
[Pontus Vision](https://www.pontusvision.com) is an open source platform for data mapping and management of personal data. It helps companies comply with data protection regulations, such as CCPA, LGPD and GDPR.

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

![](docs/arch-components.png)


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


## Architecture (Components)
All Pontus Vision components have been created as docker containers; the following table summarises the key components:


| Docker image                                         |Module   | Description                                     | Stateful            | Image Size | Min Memory |
|------------------------------------------------------|---------|-------------------------------------------------|---------------------|------------|------------|
|  pontusvisiongdpr/grafana                            |Comply   | Dashboard - historical KPIs and data tables     | No                  | 383MiB     | 36.25MiB   |
|  pontusvisiongdpr/pontus-comply-nginx-lgpd:latest    |Comply   | (optional) API Gateway                          | No                  | 183MB      | 4 MiB      |
|  pontusvisiongdpr/pontus-lgpd-formio:latest          |Extract  | (optional) Forms Manager (Brazilian Portuguese) | No                  | 530MB      | 123MiB     |
|  pontusvisiongdpr/pontus-lgpd-formio-mongodb:latest  |Extract  | (optional) Storage for Forms Manager            | Yes                 | 438MB      | 61MiB      |
|  pontusvisiongdpr/pontus-comply-keycloak:latest      |Comply   | (optional) Authenticator - creates JWT token    | Yes                 | 1.21GB     | 437MiB     |
|  pontusvisiongdpr/pontus-track-graphdb-odb-pt:latest |Track    | Graph Database to store data in the POLE model  | Yes                 | 2.27GB     | 5.611GiB   |
|  pontusvisiongdpr/timescaledb:latest                 |Track    | Historical time series database                 | Yes                 | 57.6MB     | 22MiB      |
|  pontusvisiongdpr/postgrest:latest                   |Track    | REST API front end to timescale db              | No                  | 115MB      | 30MiB      |
|  pontusvisiongdpr/pontus-extract-nifi:latest         |Extract  | Workflow tool to convert data to the POLE model | Depends on Workflow | 2.56GB     | 2.805GiB   |
|  jgontrum/spacyapi:all_v2                            |Extract  | (optional) Natural language processor           | No                  | 1.48GB     | 1.186GiB   |



## Getting Started

### Kubernetes
The easiest way to deploy the Pontus Vision platform locally is to start a docker desktop local kubernetes cluster, and follow the instructions below:

#### Pre-requisites:

Hardware: 16GB of memory, 256GB, and 4 cores

Software: Install docker desktop, and enable kubernetes
<details><summary>Windows Instructions</summary>

 * [Install Windows WSL2 Ubuntu 20.04](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
 * [Install Windows Docker desktop](https://docs.docker.com/docker-for-windows/install/) 
 * Enable Kubernetes on Docker Desktop:
   * Use WSL Engine: ![](docs/windows-docker-desktop-settings.jpg)
   * Enable WSL2 Integration: ![](docs/windows-docker-desktop-wsl-integration.jpg)
   * Enable Kubernetes: ![](docs/windows-docker-desktop-kubernetes.jpg)

</details> 

<details><summary>MacOS Instructions</summary>
  
 * [Install MacOS Docker Desktop](https://docs.docker.com/docker-for-mac/install/)
 * Enable Kubernetes: ![](docs/macos-dockerd-k8s.jpg)
 
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
apiVersion: kubeadm.k8s.io/v1beta2
kubernetesVersion: v1.22.2
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
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

#### Steps:

1) run the following commands (GDPR Demo):
    ```bash
    git clone https://github.com/pontus-vision/pontus-vision.git
    cd pontus-vision/k8s
    ```
    or  here is the LGPD Demo:
    ```bash
    git clone https://github.com/pontus-vision/pontus-vision.git
    cd pontus-vision/k8s-pt
    ```

1) Follow the instructions [here](k8s/README.md)
1) point a browser to http://localhost:18443/grafana/   (note: DO NOT FORGET the / at the end)
1) Use the user name lmartins@pontusnetworks.com and the default password pa55word



