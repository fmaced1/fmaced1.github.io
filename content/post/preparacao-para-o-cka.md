---
title: "Dicas para passar no exame CKA (Certified Kubernetes Administrator)"
description: "Dicas para passar no exame CKA (Certified Kubernetes Administrator)"
date: "2020-01-07"
categories:
  - "kubernetes"
  - "cka"
tags:
  - "kubernetes"
  - "cka"
cover:
    image: "https://miro.medium.com/max/700/1*A6Ka4665MBUJk44LBQHvKA.jpeg"
    alt: ""
    caption: ""
ShowToc: true
TocOpen: false
---

Intro

Esse é um guia para servir de base para os seus estudos e preparação para a prova do CKA.

Links oficiais sobre a cka:

- Sobre a certificação [[Link]](https://www.cncf.io/certification/cka/)
- O que cai na prova? [[Link]](https://github.com/cncf/curriculum)

Links úteis para estudar:
- https://ravikirans.com/cka-kubernetes-exam-study-guide/
- https://codeburst.io/the-ckad-browser-terminal-10fab2e8122e
- https://jimangel.io/post/cka-exam-for-experienced-kubernetes-operators/

|Domain                                             |Weight  | 
|:------------------------------------------------- |:-------|
|Troubleshooting	                                  |30%
|Cluster Architecture, Installation & Configuration	|25%
|Services & Networking	                            |20%
|Workloads & Scheduling	                            |15%
|Storage	                                          |10%

### 0# Não faça o tutorial kubernetes-the-hard-way logo de início

O tutorial do [@kelseyhightower](https://github.com/kelseyhightower) é excelente, porém fazer ele antes de entender os conceitos básicos do kubernetes, só vai gastar o seu tempo e te deixar mais confuso.

Mas depois de um tempo de estudo, aconselho sim que execute o tutorial pelo menos 2 vezes, tente não entrar em um modo automático, apenas copiando e colando os comandos.

[https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

### 1# Anote as respostas

```bash
for i in $(seq 1 24);do echo "$i - " ;done

#Pergunta - Peso - OK SKIP
1 - 2 OK
2 - 4 OK
3 - 8 SKIP
4 - 4 
5 - 8
...
24 - 3
```

### 2# Os atalhos mais usados do vim

![How to exit vim editor?](https://149351115.v2.pressablecdn.com/wp-content/uploads/2017/05/exitvim-1024x455.png)

O vim é um editor derivado do vi presente na maioria das distribuições linux e unix, bem complexo, mas muito eficiente.

Dominar o vim vai te ajudar muito a economizar um tempo precioso na hora do seu exame, acredite 2 horas não dá pra nada :)

| Comandos                    | Descrição    |
|:--------------------------- |:-------------|
|i                            | Habilita a inserção de texto onde está o cursor
|esc : q !                    | Sai do vim confirmando que não quer salvar (Mais usado)
|esc : w q !                  | Salva e sai do vim
|esc d 99 d                   | Apaga 99 linhas à partir do cursor       
|esc dd                       | Apaga a linha inteira onde o cursor está 
|esc : % s/x/y/g              | Faz o replace de x por y em todas as vezes que x aparece no arquivo
|esc gg                       | Move o cursor para a primeira linha do arquivo
|esc : set number             | Habilita a numeração das linhas do arquivo
|esc G                        | Move para o final do arquivo
|esc /groselha                | Procura pela palavra groselha no arquivo
|esc /groselha + n            | Pula para a próxima ocorrência
|esc /groselha + N            | Pula para a ocorrência anterior

Com esses comandos você consegue copiar, colar e apagar blocos de código:

| Comandos                         | Descrição    |
|:---------------------------      |:-------------|
|esc + V + (seta cima / baixo)     | Seleciona as linhas que serão copiadas
|y                                 | copia as linhas selecionadas
|d                                 | Apaga as linhas selecionadas
|p ou P                            | Cola as linhas selecionadas

### 3# Como splitar a tela com o TMUX

![](https://www.ocf.berkeley.edu/~ckuehl/tmux/tmux.png)

[tmux](https://www.ocf.berkeley.edu/~ckuehl/tmux/)

```terminal
sudo apt-get install tmux
```

```terminal
{prefix} = ctrl + b

ctrl + b + "                Divide a janela na horizontal
ctrl + b + %                Divide a janela na horizontal
ctrl + b + {Arrow-Key}      Muda de janela
ctrl + b + c                Cria uma nova janela
ctrl + b + p                Pula para a janela anterior
ctrl + b + n                Pula para a proxima janela
ctrl + b + {Page-up-Key}    Desliza a pagina na janela atual
ctrl + b + {Arrow-Key}      Aumenta ou diminui o tamanho da janela atual                  

ctrl + d                    Sai da janela atual
```

### 4# Deletar objetos pode te custar alguns segundos

Aqui vai uma dica quase ninguem fala e me ajudou, deletar objetos no kubernetes pode demorar alguns
segundos principalmente quando tem algum volume, no caso de deployment ou pod.

```
kubectl -f delete objeto.yaml ; ctrl+z + bg
```

O comando ctrl+z + bg coloca o comando anterior em backgroud e te libera a linha de comando para ir editando
o yml e isso economiza muito tempo, mesmo.

Se quiser voltar o comando para foreground, só digitar:

```
fg
```

### kubectl --dry-run, kubecl explain
```bash

export dry="--dry-run=client -o yaml"

kubectl run nginx --image nginx $dry > nginx_pod.yaml

kubectl create deploy nginx --image nginx $dry > deploy.yaml

```
### Como usar o ctrl + r p procurar no historico
### Gerenciar o tempo entre perguntas é a chave
### Tenha uma maquina windows de reserva, macbook da problema pra compartilhar a camera.
### Seu documento deve estar dentro do prazo de validade
### Não faça a prova de frente para uma janela, isso pode atrapalhar a visibilidade