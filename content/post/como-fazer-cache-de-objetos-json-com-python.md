---
title: "[Draft] Como fazer cache de objetos json usando python e redis"
description: "Como fazer cache de objetos json usando python e redis"
date: "2021-01-17"
categories:
  - "python"
tags:
  - "python"
  - "financial analisys"
  - "Financial Advisor Bot"
cover:
    image: "https://hackersandslackers-cdn.storage.googleapis.com/2020/02/_retina/redis-3@2x.jpg"
    alt: "Python and redis"
    caption: "Python and redis"
ShowToc: true
TocOpen: false
author: fmaced1
---

Intro
---------

Continuando a série "Financial Advisor Bot" que inicia nesse [post aqui](../dados-historicos-acoes-b3).

Nesse post irei compartilhar a solução de cache que estou usando, bem simples e direto ao ponto. O objetivo aqui é mostrar uma solução de cache que é fácil de implementar e que já irá evitar que o seu serviço fique indisponível, e de quebra irá diminuir bastante o seu tempo de resposta.

Primeiro, suba uma instância do redis
-------------------------

Se você já não tiver uma instância do redis:

Instale o docker, escolha de acordo com a sua plataforma [aqui](https://docs.docker.com/engine/install/).

Nesse [link](https://hub.docker.com/_/redis?tab=description&page=1&ordering=last_updated) você consegue ver as versões disponíveis, crie também, uma conta no ***docker hub***, precisaremos dela para conseguir fazer o download da imagem do redis.

```terminal
docker login
docker pull redis

# Caso queira outra versão, especifique depois dos : (dois pontos)
#docker pull redis:[version]

docker network create redis
docker run -d --name=redis --network redis -p 6379:6379 redis:latest
```

Usando o redis
--------------------

```python
from _redis import RedisCache

expiration_seconds = (60*60)*1 #60s

def get_data_history(ticker=str, period=str, interval=str, expiration_seconds=int):
    try:
        return RedisCache.get_redis(ticker)
    except Exception:
        data = yf.Ticker(ticker).history(period, interval, actions=False).dropna()
        RedisCache.set_value(ticker, data, expiration_seconds)
        
        return RedisCache.get_redis(ticker)

ticker = "STBP3.SA"
period = "1y"
interval = "1wk"
get_data_history(ticker, period, interval, expiration_seconds)
```

```python
# _redis.py
import redis, pickle, zlib

class RedisCache(Object):
    def __init__(self):
        redis_client = redis.StrictRedis(host='localhost', port=6379)

    def set_value(_key, _value, expiration_seconds):
        """[loads json object into redis]

        Args:
            _key ([string]): [key must be string]
            _value ([json]): [Loads json compress with zlib and store into redis]
            expiration_seconds ([int]): [life time seconds limit for data]
        """
        redis_client.setex(_key, expiration_seconds, zlib.compress(pickle.dumps(_value)))

    def get_value(_key):
        """[get content from values]

        Args:
            _key ([string]): [get json content from redis]

        Returns:
            [dict]: [json content]
        """
        return pickle.loads(zlib.decompress(redis_client.get(_value)))
```

Como fazer queries no redis?
--------------------
```terminal
docker exec -it redis redis-cli get VALE3.SA
```

Deletando tudo no redis
--------------------
```terminal
docker exec -it redis redis-cli FLUSHDB
```

Esse post faz parte da série "Financial Advisor Bot", mostrando as soluções que estou usando na construção desse "advisor", irei organizar todos os posts dessa série aqui [Financial Advisor Bot](../../tags/financial-advisor-bot/).

[Click aqui para ir para o próximo post.]()