---
title: "Canary release usando o Nginx Ingress Controller no K8s"
description: "Canary release usando o Nginx Ingress Controller no K8s"
date: "2021-04-11"
categories:
  - "Kubernetes"
tags:
  - "Canary Release"
  - "Nginx"
  - "DevOps"
cover:
    image: "https://images.pexels.com/photos/1557689/pexels-photo-1557689.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
    alt: "Rails"
    caption: "From [Pexels](https://www.pexels.com)"
ShowToc: true
TocOpen: false
author: fmaced1
---

Intro
---

O [Canary Release](https://martinfowler.com/bliki/CanaryRelease.html) é uma estratégia de deploy que consiste em rotear uma parte dos seus usuários para uma nova versão, com isso você consegue monitorar qual será o comportamento dessa nova versão sem afetar a todos os seus usuários caso ocorra algum erro. 

Há algumas maneiras de fazer isso, no [Kubernetes](https://kubernetes.io/pt/) isso é possível nativamente aumentando o número de réplicas dos pods novos e diminuindo os pods com a versão antiga, porém para ter uma porcentagem de 1% da nova versão, nós teríamos que ter necessariamente 1 pod com a versão nova e outros 99 com a versão antiga, o que não vai de encontro com a filosofia do Docker/Kubernetes que vieram para resolver a otimização de recursos entre outros problemas.

Outra forma de implementar essa estratégia é usando um Load Balancer nesse caso vamos usar o [Nginx](https://www.nginx.com/), com ele conseguimos manipular encaminhamento das requisições dizendo que uma porcentagem do tráfego irá para uma versão especifica, com isso podemos ter somente 1 pod com a nova versão e 1 com a antiga e ainda assim atender 1% das transações com a nova versão.

![Canary Release](https://mysieve-img.s3.amazonaws.com/pub/1560011795_2019_06_08_50163e01-cb36-446d-9964-594bf25e8494.png)

Instalação no cluster Kubernetes
---

Primeiro faça o clone do projeto https://github.com/fmaced1/canary-release-nginx-ingress-controller

```bash
git clone https://github.com/fmaced1/canary-release-nginx-ingress-controller
```

Para essa demo, iremos usar o namespace canary, mude nos arquivos **yaml** para o namespace que preferir.

Instale o nginx ingress controller:
```bash
kubectl apply -f nginx-ingress-controller/ingress-nginx-manifests.yaml -f nginx-ingress-controller/expose-ingress-nginx.yaml

kubectl rollout status deploy nginx-ingress-controller -n ingress-nginx -w
```

Se você estiver em um cluster Kubernetes que não tenha um Load Balancer, instale o MetalLB ele irá atribuir um ip público ao seu Nginx (Ingress Controller), se você estiver em um ambiente cloud provavelmente você já tem um [LB do seu provider](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer).

Ajuste o range de ips que serão alocados para o MetalLB gerenciar:
```yaml
# metallb/configmap-metallb.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.x.y-192.168.x.z # ajuste aqui o range de ips
```

Instale o MetalLB para ter um loadbalancer:
```bash
kubectl apply -f metallb/configmap-metallb.yaml
kubectl apply -f metallb/metallb-manifests.yaml
```

Canary release
---

Faça o deploy da aplicação v1:
```bash
# app-v1.yaml contém o deploy e o svc
# ingress-v1.yaml contém a rota
kubectl apply -f nginx-canary/apps/app-v1.yaml -f nginx-canary/apps/ingress-v1.yaml
```

Agora faça o deploy da segunda versão:
```bash
# app-v2.yaml contém o deploy e o svc
kubectl apply -f nginx-canary/apps/app-v2.yaml
```

Como não temos um dns, vamos colocar o nome da maquina no /etc/hosts apontando para um nome qualquer:
```bash
export IP_LOADBALANCER_METALLB="192.168.x.y"
echo "$IP_LOADBALANCER_METALLB k8s.local" >> /etc/hosts
```

Liste o serviço ingress-nginx para saber o ip que a sua app irá responder, esse ip irá responder por **k8s.local**.

```bash
kubectl get svc ingress-nginx -n ingress-nginx
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
ingress-nginx   LoadBalancer   10.106.17.108   192.168.x.y   80:31574/TCP   53m
```

Depois disso conseguimos fazer uma requisição para a rota da aplicação, deixe esse comando rodando em outro terminal:
```bash
count=0; while sleep 0.3; do let count+=1 ;echo $count - $(curl -s k8s.local); done
# output
1 - Host: my-app-v1-84ff7f48cc-kcn57, Version: v1.0.0
2 - Host: my-app-v1-84ff7f48cc-kcn57, Version: v1.0.0
3 - Host: my-app-v1-84ff7f48cc-kcn57, Version: v1.0.0
```

Agora vamos dividir o tráfego, 10% para o svc app-v2 e o resto continua no svc da app-v1:
```bash
kubectl apply -f nginx-canary/by-weight/ingress-v2-canary.yaml
```

#### Veja que de 300 requisições apenas 32 foram para app v2:
```bash
bash canary/nginx-canary/curl-canary.sh k8s.local
...
v1: 290 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 291 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 292 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 293 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 294 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 295 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 296 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 297 v2: 30 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 297 v2: 31 - Host: my-app-v2-dfdff8845-n6bml, Version: v2.0.0
v1: 298 v2: 31 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 299 v2: 31 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 300 v2: 31 - Host: my-app-v1-84ff7f48cc-4d9kq, Version: v1.0.0
v1: 300 v2: 32 - Host: my-app-v2-dfdff8845-n6bml, Version: v2.0.0
```

Quando estiver satisfeito com a app-v2, exclua o ingress-canary:
```bash
kubectl delete -f nginx-canary/by-weight/ingress-v2-canary.yaml
```

E vire todo o tráfego para a app-v2
```bash
kubectl apply -f nginx-canary/apps/ingress-v2.yaml
```