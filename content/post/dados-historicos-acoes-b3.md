---
title: "Fazendo o download dos dados históricos de ações usando o yfinance"
description: "Fazendo o download dos dados históricos de ações usando o yfinance"
date: "2021-01-17"
categories:
  - "Python"
tags:
  - "Python"
  - "Financial Analisys"
  - "Financial Advisor Bot"
cover:
    image: "https://repository-images.githubusercontent.com/91948540/e2b14a80-7fc7-11e9-8b9b-5e1f56b0052a"
    alt: "Yahoo! Finance market data downloader"
    caption: "Yahoo! Finance market data downloader"
ShowToc: true
TocOpen: false
author: fmaced1
---

Intro
---------

Sempre me interessei pelo mercado financeiro e por toda a tecnologia que esse mercado já usa de ferramenta, como por exemplo [HFT's (High-Frequency Trading)](https://www.investopedia.com/terms/h/high-frequency-trading.asp#:~:text=High%2Dfrequency%20trading%2C%20also%20known,orders%20based%20on%20market%20conditions.) e [Quantitative Trading](https://www.investopedia.com/terms/q/quantitative-trading.asp), temas que unem o melhor do mercado de tecnologia e financeiro.

Pesquisando sobre o tema vi que grandes bancos já usam essas e outras tecnologias para ajudar na tomada de decisão ou para recomendar investimentos para os seus clientes, e pensando em uma escala menor decidi criar um advisor que pudesse me ajudar a analisar todas as ações da bolsa brasileira de forma massiva e me mostrasse apenas aquelas ações que estivessem com algum sinal "interessante" com base em alguns parâmetros.

> Bom, mas como e onde conseguir os dados para fazer essas análises?

Navegando bastante entre um post e outro encontrei o [post](https://aroussi.com/post/python-yahoo-finance) do Ran Aroussi criador dessa lib fantástica escrita em python, era exatamente o que eu precisava para começar o meu projeto de bot que iria fazer todo o trabalho chato no meu lugar.

Como instalar e usar a lib yfinance
-------------------------

Para usar a lib yfinance voce vai precisar ter o **python >=3.4** e o **pip** instalado, veja aqui como instalar no [Windows](https://python.org.br/instalacao-windows/), [Linux](https://python.org.br/instalacao-linux/) e [MacBook](https://python.org.br/instalacao-mac/)

Com o python e pip instalados, execute o comando à seguir no terminal:

```terminal
pip install yfinance --upgrade --no-cache-dir
```

Pronto, agora voce já consegue comecar a usar.

Fazendo o download de dados históricos uma ação por vez
--------------------

Primeiro crie um arquivo com a extensão `*.py` e adicione as seguintes linhas:

```python
import yfinance as yf

ticker = "VALE3.SA"
period = "1y"
interval = "1wk"

historical_data = yf.Ticker(ticker).history(period, interval, actions=False).dropna()

print(historical_data)

"""
                 Open       High        Low      Close       Volume
Date                                                               
2019-12-29  51.497285  52.313177  51.065340  51.766048   46722600.0
2020-01-05  51.641265  52.188394  50.921359  51.218922   88179900.0
2020-01-12  51.487684  54.799253  51.362899  54.712864  126412900.0
2020-01-19  54.712866  55.058422  51.535679  51.641266  102226200.0
2020-01-26  49.587132  49.999879  47.801764  48.252907  138220500.0
"""
```

> Vou fazer uma série de posts, mostrando as soluções que estou usando na construção desse "advisor", irei organizar todos os posts dessa série na tag [Financial Advisor Bot](../../tags/financial-advisor-bot/).

[Click aqui para ir para o próximo post.](../como-fazer-cache-de-objetos-json-com-python/)

> No final iremos gerar um relatório igual à esse:

![Analise](../images/B3SA3.SA.jpeg)