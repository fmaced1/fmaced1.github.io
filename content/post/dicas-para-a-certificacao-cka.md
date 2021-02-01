---
title: "Dicas para a certificação CKA (Certified Kubernetes Administrator)"
description: "Dicas para a certificação CKA (Certified Kubernetes Administrator)"
date: "2020-01-07"
categories:
  - "Kubernetes"
  - "CKA"
tags:
  - "Kubernetes"
  - "CKA"
cover:
    image: "https://miro.medium.com/max/700/1*A6Ka4665MBUJk44LBQHvKA.jpeg"
    alt: ""
    caption: ""
ShowToc: true
TocOpen: false
---

Intro
---

Pretendo compartilhar aqui algumas dicas que não estão na maioria dos posts que vi pela internet quando estava me preparando para a prova.

Esse post não é um guia de estudos para a certificação CKA, mas se você está procurando por um, esses posts estão bem completos:

- https://ravikirans.com/cka-kubernetes-exam-study-guide/
- https://codeburst.io/the-ckad-browser-terminal-10fab2e8122e
- https://jimangel.io/post/cka-exam-for-experienced-kubernetes-operators/

#### Links oficiais sobre a cka:

- Sobre a certificação [[Link]](https://www.cncf.io/certification/cka/)
- O que cai na prova? [[Link]](https://github.com/cncf/curriculum)

#### Principais tópicos e seus respectivos pesos:

|Domain                                               |Weight  | 
|:--------------------------------------------------- |:-------|
|Troubleshooting	                                  |30%
|Cluster Architecture, Installation & Configuration	  |25%
|Services & Networking	                              |20%
|Workloads & Scheduling	                              |15%
|Storage	                                          |10%

Não faça o tutorial kubernetes-the-hard-way logo de início
---

O tutorial do [@kelseyhightower](https://github.com/kelseyhightower) é excelente, porém acredito que não é uma boa idéia investir um tempo considerável, executando um passo a passo que você não irá entender muita coisa do que fez quando terminar.

Depois de um tempo de estudo, quando já estiver entendendo como funciona os principais componentes, aconselho sim que execute o tutorial pelo menos 2 vezes, tente não entrar em um modo automático, apenas copiando e colando os comandos.

[https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

Dominando o vim
---

![How to exit vim editor?](https://149351115.v2.pressablecdn.com/wp-content/uploads/2017/05/exitvim-1024x455.png)

O vim é um editor derivado do vi presente na maioria das distribuições linux e unix, bem complexo, mas muito eficiente, no exame você terá apenas uma aba com um terminal linux no caso um ubuntu.

Dominar o vim vai te ajudar muito a economizar um tempo precioso na hora do seu exame, acredite 2 horas não dá pra nada, já que são 24 perguntas totalmente práticas :)

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
|esc /texto_exemplo           | Procura pela palavra texto_exemplo no arquivo
|esc /texto_exemplo + n       | Pula para a próxima ocorrência
|esc /texto_exemplo + N       | Pula para a ocorrência anterior

Com esses comandos você consegue copiar, colar e apagar blocos de código:

| Comandos                         | Descrição    |
|:---------------------------      |:-------------|
|esc + V + (seta cima / baixo)     | Seleciona as linhas que serão copiadas
|y                                 | copia as linhas selecionadas
|d                                 | Apaga as linhas selecionadas
|p ou P                            | Cola as linhas selecionadas

Como splitar a tela com o TMUX
---

![](https://www.ocf.berkeley.edu/~ckuehl/tmux/tmux.png)

O [tmux](https://www.ocf.berkeley.edu/~ckuehl/tmux/) não vem instalado por padrão no servidor que é usado no exame, para instalar é bem simples basta rodar isso:

```terminal
sudo apt -y install tmux

# caso não funcione, tente rodar os seguintes comandos e depois rodar o install novamente:
# sudo apt update
# sudo apt upgrade
```

Principais comandos tmux que podem ser usados no exame:

```terminal
# O prefix deverá ser usado antes de todos os comandos ao tmux.
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

Deletar objetos pode te custar alguns segundos
---

Aqui vai uma dica quase niguém fala e que me ajudou bastante, deletar objetos no kubernetes pode demorar alguns
segundos principalmente quando tem alguma secret, configmap ou volume atrelada à ela, no caso de deployment ou pod.

```
kubectl -f delete objeto.yaml ; ctrl+z + bg
```

O comando ctrl+z + bg coloca o comando anterior em backgroud e te libera a linha de comando para ir editando
o yml e isso economiza muito tempo, mesmo.

Se quiser voltar o comando para foreground, só digitar:

```
fg
```

Kubectl aliases e autocompletion
---

Sem dúvida os aliases mais importantes são o ```k="kubectl"``` e o ```$dry```, não usei muitos aliases como nesse [projeto](https://github.com/ahmetb/kubectl-aliases), porque sinceramente não achei que valesse muito a pena, afinal iria acabar perdendo mais tempo tentando lembrar dos comandos do que realmente fazendo o que precisava.

```bash
export dry="--dry-run=client -o yaml"

# Cria um yaml com o manifest de um pod nginx
kubectl run nginx --image nginx $dry > nginx_pod.yaml

# Mesmo que o anterior, porém aqui cria um deployment ao invés de um pod
kubectl create deploy nginx --image nginx $dry > deploy.yaml
```

E para habilitar o autocomplete do kubectl, aqui está o link da [documentação oficial](https://kubernetes.io/docs/tasks/tools/install-kubectl/#enable-kubectl-autocompletion) 

```bash
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
```

Anote as respostas
---

Logo que iniciar o exame, rode esse comando à seguir no terminal:

```bash
for i in $(seq 1 24);do echo "$i - " ;done
```

Isso irá gerar 24 linhas no seguinte formato: 

```bash
1 -
2 -
3 -
4 -
...
24 -
```

Depois copie e cole no notepad da plataforma, assim você conseguirá marcar as questões feitas e o peso.

No final o meu notepad do exame ficou algo parecido com isso:

```bash
Questões, Peso, OK/NOK
1 - 4 - OK
2 - 3 - OK
3 - 7 - NOK
4 - 4 - OK
...
24 - 8 - NOK
```

Outras dicas
---

  - Tenha uma máquina windows de reserva, quando fiz o exame perdi cerca de 20 minutos entre ficar tentando compartilhar a câmera e trocar de notebook.
  - Seu documento deve estar dentro do prazo de validade, seja ele RG ou CNH, eles realmente olham a data de validade, aliás a imagem da webcam tem que estar nítida ao ponto de conseguir ver o que está escrito.
  - Não faça a prova de frente para uma janela, isso pode atrapalhar a visibilidade
