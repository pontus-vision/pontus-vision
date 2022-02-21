copiei o ambiente basico do github da PontusVision:
```
mkdir ~/work/pv/
cd ~/work/pv
git clone https://github.com/pontus-vision/pontus-vision.git
```
Criei segredos basicos para o k8s funcionar

quando comecei o cluster usando o kind acabou a memoria, e o k8s cluster ficou instavel.

Entao decidi remover o microk8s:
```
sudo snap remove microk8s
```

Escolhi opcao 2 destas duas opcoes:
  1) - mais pesada - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

  2) - mais leve - https://rancher.com/docs/k3s/latest/en/installation/install-options/
```
curl -sfL https://get.k3s.io | sh -

echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
sudo chmod 644  /etc/rancher/k3s/k3s.yaml

```

