
# Pontus Vision Brasil

  [Pontus Vision](https://www.pontusvision.com.br) é uma plataforma de código aberto para mapeamento de dados e gerenciamento de dados pessoais. Ele ajuda as empresas a cumprir os regulamentos de proteção de dados, como **GDPR** da União Europeia, **LGPD** do Brasil e **CCPA** do Estado da Califórnia (EUA).

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

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/arch-components.png) <!-- atualizar imagem !! -->


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
  |  pontusvisiongdpr/pontus-track-graphdb-odb-pt:1.15.55    |Track    | Banco de dados gráfico para armazenar dados no modelo POLE  | Sim                 | 1.04GB     | 4.5GiB     |
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

**<details><summary>Removendo Snap (opcional - não necessário para WSL)</summary>**

  Antes da instalação do `k3s`, remova o gerenciador de pacotes `Snap`, pois ele consome muita CPU em servidores pequenos; isso pode ser feito executando os seguintes comandos:

  ```bash
  export SNAP_LIST=$(snap list) && \
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

  yes | sudo apt autoremove --purge snapd gnome-software-plugin-snap

  rm -fr ~/snap && sudo apt-mark hold snapd
                                             
  ```

</details>

**<details><summary>Atualizar o servidor e baixar ferramentas:</summary>**

  ```
  sudo apt update && \                                          
  sudo apt upgrade -y && \                                      
  sudo apt install -y git curl jq ubuntu-server python3-pip && \
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
  chmod 700 get_helm.sh && \
  ./get_helm.sh
                                           
  ```

</details>

**<details><summary>Instalação do _Certificate Manager_</summary>**

  Depois de instalar o helm, crie o namespace _cert-manager_ e instale o _cert manager_; isso permitirá que os certificados https sejam gerenciados:

  ```
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  kubectl create namespace cert-manager && \
  helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.6.1 \
    --set installCRDs=true
                                          
  ```

</details>

<br/>

# Instalação da Demo

  A maneira mais fácil de implantar a plataforma Pontus Vision é executar uma VM com sistema operacional Ubuntu 20.04, com um mínimo de 16 GB de RAM, 4 núcleos e 250 GB de espaço em disco.

  Observe que a VM deve ser chamada `pv-demo`; caso contrário, as regras do Keycloak terão que ser alteradas para permitir o tráfego de outros prefixos.

<br/>

  > **AVISO**: Certifique-se de que a VM usada para a demonstração se chama **pv-demo**

--------------------------------------------------------------------
 <a href="#user-content-mudar-host" id="mudar-host"></a>
 _Se o nome do host for diferente de `pv-demo`, siga estas etapas:_
**<details><summary>Alterar a variável de ambiente 'PV_HOSTNAME'</summary>**
  Mude a variável PV_HOSTNAME no arquivo .bashrc do usuário que roda o script de inicialização (./start-env-lgpd.sh).  

```bash
  export PV_HOSTNAME="mydemo.myorg.com"
```
Note que terá que ser usado o mesmo nome exatamente aqui e no Browser, portanto se o browser usar https://mydemo/pv, não irá funcionar; será preciso usar https://mydemo.myorg.com no browser e na etapa abaixo do keycloak.

  </details>

**<details><summary>Alterar o redirecionamento de URI do Keycloak</summary>**

  Para poder alterar o redirecionamento de URI no Keycloak, é necessário fazer login como **Superusuário**. Para fazer isso, acesse o link a seguir => [https://\<adicione-o-hostname-aqui\>/auth/](https://$\<adicione-o-hostname-aqui\>/auth/) e autentique-se com a credencial padrão do administrador **nome de usuário: admin / senha: admin**.

  Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Depois clique em **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > Esta é a página inicial do Keycloak. Clique em **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname2.png)

  > No painel principal, localize **Clients** em **Realm settings** no menu à esquerda.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname3.png)

  > Na tabela Clients, clique em **broker** (Client ID).

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname5.png)

  > Na página do broker, role para baixo até **Valid Redirect URIs**. O último valor desta lista sempre será o padrão `https://pv-demo/*`. Altere para `https://\<adicione-o-hostname-aqui\>/*`.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname9.png)

  > Role para baixo e clique em **Save** e aguarde o pop-up de mensagem **Success!**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname6.png)

  > Volte para a página **Clients** e clique no Client ID **test** e faça as mesmas alterações feitas anteriormente.

  Isso deve resolver! Agora você poderá acessar o Dashboard usando [https://\<adicione-o-hostname-aqui\>/pv](https://\<adicione-o-hostname-aqui\>/pv).

  **TALVEZ SEJA NECESSÁRIO UM REINÍCIO DO AMBIENTE**. Verifique a seção **Reiniciar o ambiente k3s** abaixo.

</details>

--------------------------------------------------------------------

<br/>

  Se você quiser experimentar dados próprios, será necessária a CONFIGURAÇÃO de segredos, apis e armazenamento. Substitua as pastas storage/ e secrets/ seguindo as instruções da próxima seção MINUCIOSAMENTE.

  O _helm chart_ usado para configurar a plataforma Pontus Vision existe neste repositório. Clone este repositório e utilize a Demo GDPR ou LGPD:

  ```bash
  git clone https://github.com/pontus-vision/pontus-vision.git && \
  cd pontus-vision/k3s
                                    
  ```

  Execute o seguinte para iniciar a demonstração do GDPR:

  ```bash
  ./start-env-gdpr.sh
  # Observação: O comando acima pode falhar na primeira vez,
  # pois o k3s estará baixando imagens grandes e pode atingir o tempo limite.
  # Se isso acontecer, execute-o novamente
  ```

  Ou... Execute o seguinte para iniciar a demonstração da LGPD:

  ```bash
  ./start-env-lgpd.sh
  # Observação: O comando acima pode falhar na primeira vez,
  # pois o k3s estará baixando imagens grandes e pode atingir o tempo limite.
  # Se isso acontecer, execute-o novamente
  ```

<br/>

# Instalação Customizada

  A maneira mais fácil de implantar a plataforma Pontus Vision é executar uma VM com sistema operacional Ubuntu 20.04, com um mínimo de 16 GB de RAM, 4 núcleos e 250 GB de espaço em disco.

<br/>

  > **AVISO**: Certifique-se de que a VM usada para a demonstração se chama **pv-demo**

--------------------------------------------------------------------

 _Se o nome do host for diferente de `pv-demo`, siga estas etapas:_

**<details><summary>Alterar o redirecionamento de URI do Keycloak</summary>**

  Para poder alterar o redirecionamento de URI no Keycloak, é necessário fazer login como **Superusuário**. Para fazer isso, acesse o link a seguir => [https://\<adicione-o-hostname-aqui\>/auth/](https://$\<adicione-o-hostname-aqui\>/auth/) e autentique-se com a credencial padrão do administrador **nome de usuário: admin / senha: admin**.

  Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Depois clique em **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > Esta é a página inicial do Keycloak. Clique em **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname2.png)

  > No painel principal, localize **Clients** em **Realm settings** no menu à esquerda.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname3.png)

  > Na tabela Clients, clique em **broker** (Client ID).

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname5.png)

  > Na página do broker, role para baixo até **Valid Redirect URIs**. O último valor desta lista sempre será o padrão `https://pv-demo/*`. Altere para `https://\<adicione-o-hostname-aqui\>/*`.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname9.png)

  > Role para baixo e clique em **Save** e aguarde o pop-up de mensagem **Success!**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/hostname6.png)

  > Volte para a página **Clients** e clique no Client ID **test** e faça as mesmas alterações feitas anteriormente.

  Isso deve resolver! Agora você poderá acessar o Dashboard usando [https://\<adicione-o-hostname-aqui\>/pv](https://\<adicione-o-hostname-aqui\>/pv).

  **TALVEZ SEJA NECESSÁRIO UM REINÍCIO DO AMBIENTE**. Verifique a seção **Reiniciar o ambiente k3s** abaixo.

</details>

--------------------------------------------------------------------

<br/>

  O _helm chart_ usado para configurar a plataforma Pontus Vision existe neste repositório. Clone este repositório e utilize a Demo GDPR ou LGPD:

  ```bash
  git clone https://github.com/pontus-vision/pontus-vision.git && \
  cd pontus-vision/k3s
                                       
  ```

**<details><summary>Arquivos Secret</summary>**

  Esta demonstração usa _secrets_ do Kubernetes para armazenar várias senhas e credenciais confidenciais. Você precisará criar os seus próprios, mas para facilitar, criamos um arquivo `tar.gz` com formatos de exemplo.

  > O script `create-env-secrets.sh` é responsável pelos _secrets_.

   Na primeira vez que o ambiente for iniciado, ele verificará se existe uma pasta `secrets/` (caso você queira adicionar seus próprios), caso contrário ele usará `sample-secrets.tar.gz` por padrão. Para criar a pasta de forma compatível, siga abaixo ↓

<br/>

**Modifique a estrutura de arquivos da pasta */secrets***

  Você deve organizar uma estrutura de diretórios semelhante ao exemplo abaixo. Certifique-se de criar a pasta `secrets/` dentro de `k3s/`. Além disso, seja consistente com os **nomes de variáveis dos secrets/ variáveis de ambiente**, pois você precisará usá-los nos arquivos HELM `templates/` yaml.
  
  > **AVISO**: _secrets_ localizados dentro da pasta env/ devem ser modificados SOMENTE por USUÁRIOS EXPERIENTES. Adicione seus outros _secrets_ à pasta PRINCIPAL secrets/.

  Aqui está a estrutura em árvore de pastas e arquivos do `secrets/` padrão gerado via `sample-secrets.tar.gz`:

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
  ├── google-json # exemplo                   
  └── microsoft-json # exemplo                
  ```

  E este é o arquivo _secret_ do modelo YAML para `pontus-timescaledb` no diretório `pontus-vision\k3s\helm\pv\templates` usado pelo HELM-K3S. Observe como os nomes dos _secrets_ `POSTGRES_USER` e `POSTGRES_PASSWORD` são utilizados.

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

  Aqui estão outros exemplos/modelos de _secrets_:

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

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-1.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-2.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-3.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-4.jpg)
  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/azure-5.jpg)

</details>

</details>

**<details><summary>Configurando os _helm values_</summary>**

  O arquivo _values_ `pontus-vision/k3s/helm/custom-values.yaml` tem detalhes de configuração que variam de ambiente para ambiente. Aqui está um exemplo:

  ```yaml
  # Este é um arquivo formatado em YAML.
  # Declare variáveis aqui para serem passadas para seus templates.

  pvvals:
    imageVers:
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb${PV_IMAGE_SUFFIX}:1.15.55"
      grafana: "pontusvisiongdpr/grafana${PV_IMAGE_SUFFIX}:1.13.2"
      pvextract: "pontusvisiongdpr/pv-extract-wrapper:1.13.2"

    storagePath: "${PV_STORAGE_BASE}" # Variável de Ambiente
    hostname: "${PV_HOSTNAME}"
    # para obter a chave pública do keycloak, faça um HTTP GET para a seguinte URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "*********************************************************"

    # altere os valores conforme necessário
    # Seja consistente com as variáveis!
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

      # Adicione/modifique seus próprios cronjobs|pods|services
      # Seja consistente com as variáveis!
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

<br/>

</details>

**<details><summary>Criar armazenamento de volumes persistentes (*persistent volumes*)</summary>**

  > Este passo é **AUTO EXECUTADA** !!
  > Para garantir que funcione sem problemas, certifique-se de configurar tudo em k3s\helm\custom-values.yaml !!

  Esta etapa é importante para garantir que os dados do k3s sejam mantidos usando **volumes persistentes**. O script `create-storage-dirs.sh` é executado quando o ambiente (Demo) é iniciado. Ele é responsável por criar a estrutura de pastas de armazenamento.

  As pastas internas `extract/` são criadas usando as chaves (_keys_) do map no `custom-values.yaml`.

  Veja como funciona:

  ```yaml
      kpi:
      command:
        - /bin/bash
        - -c
        - sleep 10 && getent hosts graphdb-nifi &&  /usr/bin/node dist/kpi-handler/app.js
      env:
        - name: PV_POSTGREST_PREFIX
          value: "http://pontus-postgrest:3000"

    # Nomeie seus cronjobs|pods|services adequadamente
    cronjob-x: # <--- este será o nome da pasta em /storage/extract/cronjob-x
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
  
  Aqui está a estrutura de árvore resultante em `/storage/extract`:

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

Somente quando configurados os passos anteriores, volte para a pasta `pontus-vision/k3s` para reproduzir sua Demo personalizada.

Execute o seguinte para iniciar a demo personalizada do GDPR:

```bash
./start-env-gdpr.sh
# Observação: O comando acima pode falhar na primeira vez,
# pois o k3s estará baixando imagens grandes e pode atingir o tempo limite.
# Se isso acontecer, execute-o novamente
```

Ou... Execute o seguinte para iniciar a demo personalizada da LGPD:

```bash
./start-env-lgpd.sh
# Observação: O comando acima pode falhar na primeira vez,
# pois o k3s estará baixando imagens grandes e pode atingir o tempo limite.
# Se isso acontecer, execute-o novamente
```

<br/>

# Gerenciamento

**Acessando o Grafana (Dashboard Pontus Vision)**

  1. Aponte um navegador para [https://pv-demo/pv](https://pv-demo/pv)

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pv-demo-1.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pv-demo-2.png)

  > Depois clique em **Continue to pv-demo (unsafe)**.

  2. Use o nome de usuário `lmartins@pontusnetworks.com` e a senha padrão `pa55word!!!`

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

**<details><summary>Pontus Vision imageVers</summary>**

  A Pontus Vision está constantemente melhorando e atualizando suas imagens de contêiner para acompanhar as últimas atualizações de tecnologia e segurança. Para alterar as versões, basta alterar o valor `pvvals.imageVers` em `pontus-vision/k3s/helm/values-gdpr.yaml` e `pontus-vision/k3s/helm/values-lgpd.yaml` e reiniciar o k3s env (veja abaixo a seção **Reiniciar o ambiente k3s**).

  ```yaml
  # Este é um arquivo formatado em YAML.
  # Declare variáveis aqui para serem passadas para seus templates.

  pvvals:
    imageVers: # <---
      graphdb: "pontusvisiongdpr/pontus-track-graphdb-odb${PV_IMAGE_SUFFIX}:1.15.55"
      grafana: "pontusvisiongdpr/grafana${PV_IMAGE_SUFFIX}:1.13.2"
      pvextract: "pontusvisiongdpr/pv-extract-wrapper:1.13.2"

    storagePath: "${PV_STORAGE_BASE}"
    hostname: "${PV_HOSTNAME}"
    # para obter a chave pública do keycloak, faça um HTTP GET para a seguinte URL: https://<hostname>/auth/realms/pontus
    keycloakPubKey: "*********************************************************"

  # (...)
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

  > Poderá ser necessário remover algumas pastas internas do storage/
  > ou toda a pasta em sí para que os arquivos state.json atuais sejam excluídos
  > e as atualizações sejam aplicadas no próximo _kickoff_.

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

**<details><summary>Listando os nodes | pods | cronjobs | services do k3s</summary>**

  > Para uma listagem de todos os _nodes_ (nós) execute o comando `$ kubectl get nodes`.

  ```
  NAME      STATUS   ROLES                  AGE    VERSION
  pv-demo   Ready    control-plane,master   3d2h   v1.22.7+k3s1
  ```

<br/>

  > Para examinar os pods, execute `$ kubectl get pod(s) [-o wide]` e uma tabela de guias semelhante é exibida:

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

<br/>

  > Para obter detalhes de um pod em específico, execute `$ kubectl describe pod(s) <pod name>`. Saída para pod graphdb-nifi:

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

> Para listar todos os cronjobs rodando, execute `$ kubectl get cronjobs(.batches)`.

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

> Para mostrar os _services_ (serviços) digite `$ kubectl get services`.

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

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/k3s-taint-1.png)

  OU, ao executar `$ kubectl describe nodes <node name>` a seção **Taints** é diferente de `<none>`:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/k3s-taint-2.png)

  Então, copie os Taints que foram mostrados para o nó específico e execute o seguinte comando para **untain** cada um deles:

  ```
  kubectl taint nodes <node name> [Taint]-
  ```

  Por exemplo:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/k3s-taint-3.png)

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

  Preste atenção no `wa` (Tempo gasto na espera de I/O), quanto menor, melhor!

</details>

<br/>

## Criação de Usuários

**<details><summary>Keycloak</summary>**

  O Keycloak é um software *open source* usado com as soluções Pontus Vision para permitir logon único, permitindo gerenciamento de identidade e acesso.

  Para poder adicionar/atualizar/alterar usuários no Keycloak, é necessário fazer login como **Superusuário**. Para fazer isso, acesse o link a seguir => [https://\<adicione-o-hostname-aqui\>/auth/](https://$\<adicione-o-hostname-aqui\>/auth/) e autentique-se com a credencial padrão do administrador **nome de usuário: admin / senha: admin**.

  Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Depois clique em **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > Esta é a página inicial do Keycloak. Clique em **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-c.png)

  > No painel principal, localize **Users** em **Manage** no menu à esquerda.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-3.png)

  > Na parte direita, clique em **Add user**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-5.png)

  > Preencha os campos (ao menos os campos obrigatórios) \**ID é incrementado automaticamente*. Você também pode adicionar **User actions**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-6.png)

  > Por fim, clique em **Save**.

</details>

**<details><summary>Grafana</summary>**

  O Grafana é um aplicativo *open source* web multiplataforma de análise e visualização interativa. Conectado aos produtos da Pontus Vision, fornece tabelas, gráficos e alertas na web.

  O mesmo privilégio de **Superusuário** é necessário aqui... vá para a página de login principal [https://\<adicione-o-hostname-aqui\>/pv](https://\<adicione-o-hostname-aqui\>/pv) e insira as credenciais admin enviadas por seu administrador.

  Aqui estão algumas capturas de tela das etapas de como criar um novo usuário:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Depois clique em **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-1.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-2.png)

  > Esta é a página principal do Grafana. Localize o ícone **Escudo** (Server Admin), dentro dele, clique em **Users**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-3.png)

  > Aparecerá uma tabela contendo todos os usuários cadastrados. No canto superior direito, clique no botão azul **New user**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-4.png)

  > Preencha os campos (ao menos os campos obrigatórios), depois clique no botão azul **Create user**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-5.png)

  > Ao clicar no usuário recém-criado você pode editar suas Informações, Permissões, Organizações a que pertence e abrir Sessões.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/grafana-6.png)

  > Para alterar a função de um usuário em uma organização, clique em **Change role** (Em *Organisations*), escolha a função no menu suspenso e clique em **Save**.

</details>

<br/>

## Redefinição de senha

**<details><summary>Instruções</summary>**

  Para redefinir a senha de um usuário, basta alterá-la usando o logon único e o gerenciamento de acesso do Keycloak. Vá para o seguinte link => [https://\<adicione-o-hostname-aqui\>/auth/](https://\<adicione-o-hostname-aqui\>/auth/) e autentique-se com a credencial padrão do administrador **nome de usuário : admin / senha: admin**.

  Aqui estão algumas capturas de tela das etapas de como redefinir a senha de um usuário:

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-a.png)

  > Ao acessar o link pela primeira vez, o navegador avisará que a conexão não é privada, basta ignorar e clicar em **Advanced**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-b.png)

  > Depois clique em **Proceed to \<hostname\> (unsafe)**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-1.png)

  > Esta é a página inicial do Keycloak. Clique em **Administration Console**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-2.png)

  > Insira as credenciais padrão e clique em **Sign in**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-c.png)

  > No painel principal, localize **Users** em **Manage** no menu à esquerda.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/keycloak-4.png)

  > Clique em **View all users** ao lado da barra de pesquisa. Em seguida, uma tabela contendo todos os usuários registrados será exibida. Na coluna **Actions**, clique em **Edit**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-1.png)

  > Altere a guia **Credentials**, na parte superior. Em seguida, em **Reset Password**, digite a nova senha.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-2.png)

  > Você pode ativar o botão **Temporary**, para forçar o usuário a alterar a senha assim que fizer login pela primeira vez.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-3.png)

  > Em seguida, clique no botão **Reset Password**. Um pop-up será exibido para confirmar a alteração. Clique no botão vermelho **Reset password**.

  ![](https://raw.githubusercontent.com/pontus-vision/README-images/main/pass-reset-4.png)

  > Então a página será recarregada e um popup verde aparecerá com a mensagem **Success**.

</details>
