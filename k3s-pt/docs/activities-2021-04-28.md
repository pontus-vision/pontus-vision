
openvpn file - mudei a route para ser 192.168.1.0 255.255.255.0 (a rota original nao dava para contecar ao servidor)
instalei kubectl - para controlar clusters de kubernetes:

```
snap install kubectl
```
  
Criei .ssh key  (para facilitar a comunicacao c/ o github):
```
  lgpddev@lgpddev:~$ ssh-keygen
  Generating public/private rsa key pair.
  Enter file in which to save the key (/home/lgpddev/.ssh/id_rsa):
  Created directory '/home/lgpddev/.ssh'.
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again:
  Your identification has been saved in /home/lgpddev/.ssh/id_rsa
  Your public key has been saved in /home/lgpddev/.ssh/id_rsa.pub
  The key fingerprint is:
  SHA256:OqLjYQ0ZeTKgyjLZstjvL8QiJlfJ+9WJiqTf5o1Akq8 lgpddev@lgpddev
  The key's randomart image is:
  +---[RSA 3072]----+
  |.                |
  |.. .             |
  |. =...           |
  |oo B+            |
  |*.*o..  So .     |
  |=*o*=  .o o      |
  |=o+==ooo         |
  | .o=o+++         |
  | .E++== .        |
  +----[SHA256]-----+
  lgpddev@lgpddev:~$ cat .ssh/id_rsa.pub
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSeaVfCBGeHvOlDMPa/dNGVeZUfblEOLujfzNsB+Uhnyw9crVwvSFuqQ8WL1bHVpa9hcGge8M7t+DTAz8KLO/dNAJod1gsFuZ43cAcg4TtXAzmkfM/FQh9l4j3KdjzzI3iQ7f/fopjsfHludq5Mhru9g44MCVGqZNfHXMzINCuPOKpdS6VJ76+4sI3fVV/gPdwtBcD8I9+tclfswqYzeDZvfENYBj6DNNenSly0Q07tqCR1uA+Ml6fwGIv/+LXBiUx2yx70ohxwFlvj0ADpfzQnqmH2MT2v27VAWff+tLRArvTBhQpqTiH1cSgExH+Nb+XYEj2sD7tc347kxOeoBV3iawtBK4fMs7elNsHPwLBDPVkSRIHMbwomtwxhrMZ/1/FrJmmCK9fiwku1yiBjLfs4XQaYOohyRPsJoU1VIf+nTIka6uxbH/m/RRCLCfZ8jnj3svpI2VWAck8xNYsi49l+n6h96si5UHeemq9tM07jU2jsKWPPxUYYsUGsJCG0H0= lgpddev@lgpddev
```

Github:
  - mudei o nome do repositorio da Totvs para letra minuscula
  - Adicionei a id_rsa.pub acima ao github como uma 'trusted key'
  - criei um novo repositorio chamado pontus-vision-k8s (para manter configuracoes do kubernetes (k8s - k + (8 letras-ubernete) + s)


clonei o pontus-vision-k8s sob o diretorio work:

```
lgpddev@lgpddev:~$ cd work/
lgpddev@lgpddev:~/work$ ls
lgpddev@lgpddev:~/work$ git clone git@github.com:Sunnyvale-Comercio-e-Representacoes/pontus-vision-k8s.git
Cloning into 'pontus-vision-k8s'...
The authenticity of host 'github.com (140.82.112.3)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com,140.82.112.3' (RSA) to the list of known hosts.
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (4/4), done.
lgpddev@lgpddev:~/work$ cd pontus-vision-k8s/
lgpddev@lgpddev:~/work/pontus-vision-k8s$
```
configurei o e-mail e usuario do git:
```
lgpddev@lgpddev:~/work/pontus-vision-k8s/docs$ git config --global user.email 'lmartins@pontusvision.com'
lgpddev@lgpddev:~/work/pontus-vision-k8s/docs$ git config --global user.name 'Leo Martins'
```

Adicionei o arquivo de activities-2021-04-28.md ao git:
```
lgpddev@lgpddev:~/work/pontus-vision-k8s/docs$ git add ./activities-2021-04-28.md
lgpddev@lgpddev:~/work/pontus-vision-k8s/docs$ git commit -am 'adicionei log de atividades'

```

Adicionei bash completion para kubernetes:
https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/

```
echo 'source <(kubectl completion bash)' >>~/.bashrc
sudo su -
kubectl completion bash >/etc/bash_completion.d/kubectl
```
adicionei o grupo docker e o lgpddev a ele
```
sudo groupadd docker              
sudo usermod -a -G docker lgpddev 
```
re-instalei docker:
```
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
 sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

```

Instalei minikube:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```
Infelizmente, o minikube nao  funcionou:
```
lgpddev@lgpddev:~$ minikube start
😄  minikube v1.19.0 on Ubuntu 20.04
✨  Automatically selected the docker driver
👍  Starting control plane node minikube in cluster minikube
🔥  Creating docker container (CPUs=2, Memory=2900MB) ...- E0428 11:05:57.772484   76297 network_create.go:79] failed to find free subnet for docker network minikube after 20 attempts: no free private network subnets found with given parameters (start: "192.168.9.0", step: 9, tries: 20)
❗  Unable to create dedicated network, this might result in cluster IP change after restart: un-retryable: no free private network subnets found with given parameters (start: "192.168.9.0", step: 9, tries: 20)
^C
```


ao inves do minikube, entao instalei kind:
```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/bin/

lgpddev@lgpddev:~$ kind create cluster
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.20.2) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Have a nice day! 👋
```
