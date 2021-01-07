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

Dicas para a prova:

https://ravikirans.com/cka-kubernetes-exam-study-guide/
https://codeburst.io/the-ckad-browser-terminal-10fab2e8122e
https://jimangel.io/post/cka-exam-for-experienced-kubernetes-operators/

### Split de tela

![](https://www.ocf.berkeley.edu/~ckuehl/tmux/tmux.png)

[tmux](https://www.ocf.berkeley.edu/~ckuehl/tmux/)

```terminal
sudo apt-get install tmux

{prefix} = ctrl + b

{prefix} "  ==> split window horizontally
{prefix} %  ==> split window horizontally
{prefix} {Arrow-Key} ==> switch pane
{prefix} c  ==> create new window
{prefix} p  ==> move to previous window
{prefix} n  ==> move to next window
{prefix} {Page-up-Key} ==> scroll-up the pane within tmux
{prefix} q  ==> to quickly flash pane numbers for easy reference to a particular pane
{Ctrl} d  ==> to exit current pane

Hold {prefix} and use {Arrow-Key} to increase/decrease the size of current pane
```

### Deletar objetos pode te custar alguns segundos

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

### Mastering VIM - ctrl+c ctrl+v, find, go to top down, indentacao em bloco, replace

```
Mark lines: Esc+V (then arrow keys)
Copy marked lines: y
Cut marked lines: d
Past lines: p or P
```

### Anote as respostas

```bash
for i in $(seq 1 24);do echo "$i - " ;done

#Pergunta - Peso - OK SKIP
1 - 2 OK
2 - 4 OK
3 - 8 SKIP
4 - 4 
5 - 8 
```
### Gerenciar o tempo eh a chave
### Tenha uma maquina windows de reserva, macbook da problema pra compartilhar a camera.
### Seu documento deve estar dentro do prazo de validade
### Não faça a prova de frente para uma janela, isso pode atrapalhar a visibilidade
### kubectl --dry-run, kubecl explain