---
title: "Fazendo o download dos dados históricos de ações usando o yfinance"
description: "Fazendo o download dos dados históricos de ações usando o yfinance"
date: "2020-12-26"
categories:
  - "python"
tags:
  - "python"
cover:
    image: "https://repository-images.githubusercontent.com/91948540/e2b14a80-7fc7-11e9-8b9b-5e1f56b0052a"
    alt: "Yahoo! Finance market data downloader"
    caption: "Yahoo! Finance market data downloader"
ShowToc: true
TocOpen: false
---

Intro
---------

Sempre me interessei pelo mercado financeiro e por toda a tecnologia que esse mercado já usa de ferramenta, como por exemplo [HFT's (High-Frequency Trading)](https://www.investopedia.com/terms/h/high-frequency-trading.asp#:~:text=High%2Dfrequency%20trading%2C%20also%20known,orders%20based%20on%20market%20conditions.) e [Quantitative Trading](https://www.investopedia.com/terms/q/quantitative-trading.asp), temas que unem o melhor do mercado de tecnologia e financeiro.

Pesquisando sobre o tema vi que grandes bancos já usam essas e outras tecnologias para ajudar na tomada de decisão ou para recomendar investimentos para os seus clientes, e pensando em uma escala menor decidi criar um advisor que pudesse me ajudar a analisar todas as ações da bolsa brasileira de forma massiva e me mostrasse apenas aquelas ações que estivessem com algum sinal "interessante" com base em alguns parâmetros.

> Bom, mas como e onde conseguir os dados para fazer essas análises?

Navegando bastante entre um post e outro encontrei o post do [Ran Aroussi](https://aroussi.com/post/python-yahoo-finance) criador dessa lib fantástica escrita em python, era exatamente o que eu precisava para comecar o meu projeto de bot que iria fazer todo o trabalho chato no meu lugar

Como instalar e usar a lib yfinance
-------------------------

Para usar a lib yfinance voce vai precisar ter o **python >=3.4** e o **pip** instalado, [vejá aqui como instalar]()

Com o python e pip instalados, execute o comando à seguir no terminal:

```terminal
pip install yfinance --upgrade --no-cache-dir
```

Pronto, agora voce já consegue comecar a usar.

Fazendo o download de dados históricos uma ação por vez
--------------------

```python
import yfinance as yf

ticker = "VALE3.SA"
period = "1y"
interval = "1wk"

historical_data = yf.Ticker(ticker).history(period, interval, actions=False).dropna()

print(historical_data)

"""              Open    High    Low    Close      Volume  Dividends  Splits
Date
1986-03-13    0.06    0.07    0.06    0.07  1031788800        0.0     0.0
1986-03-14    0.07    0.07    0.07    0.07   308160000        0.0     0.0
...
2019-04-15  120.94  121.58  120.57  121.05    15792600        0.0     0.0
2019-04-16  121.64  121.65  120.10  120.77    14059700        0.0     0.0
"""
```