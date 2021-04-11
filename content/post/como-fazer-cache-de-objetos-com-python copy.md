---
title: "Como fazer cache de objetos usando python e redis"
description: "Como fazer cache de objetos usando python e redis"
date: "2021-03-06"
categories:
  - "Python"
tags:
  - "Python"
  - "Financial Analisys"
  - "Financial Advisor Bot"
cover:
    image: "https://images.pexels.com/photos/971364/pexels-photo-971364.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"
    alt: "Velocity"
    caption: "From [Pexels](https://www.pexels.com)"
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
---

Ao invés de baixar os dados todas as vezes que precisamos dos dados históricos de uma ação, porque não guardar em cache? Afinal o yahoo atualiza as cotações só depois de 15 minutos, e para a nossa análise o que importa é a cotação semanal.

Para isso vamos criar um método/função ```get_data_history```, ela irá bater no redis e buscar os dados daquela ação, se o redis não tiver esses dados, vamos fazer o download e guardar no redis, assim nas próximas vezes os dados já estarão em cache, como vamos passar um tempo de expiração o redis vai apagar essa informação depois de 1 hora.

Nome do arquivo deve ser ***_redis.py***, porque iremos importa-lo no próximo arquivo
```python
import redis, pickle, zlib, os

class RedisCache(object):
    def __init__(self):
        
        redis_host = os.getenv('REDIS_HOST')
        redis_port = os.getenv('REDIS_PORT')
        
        if redis_host == None and redis_port == None:
            redis_host = "localhost"
            redis_port = 6379

        self.redis_client = redis.StrictRedis(host=redis_host, port=redis_port)

    def get_value(self, _key):
        """ Get content from redis

        Args:
            _key ([string])

        Returns:
            [dict]: [Dataframe]
        """
        return pickle.loads(zlib.decompress(self.redis_client.get(_key)))

    def set_value(self, _key, _value, expiration_seconds):
        """ Loads data object into redis

        Args:
            _key ([string]): [key must be string]
            _value ([json]): [Loads data to compress with zlib and store into redis]
            expiration_seconds ([int]): [life time seconds limit for data]
        """
        self.redis_client.setex(_key, expiration_seconds, zlib.compress(pickle.dumps(_value)))
```

```python
from _redis import RedisCache

expiration_seconds = (60*60)*1 #1hr

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

# Assim quando chamarmos essa função, ela irá retornar um dataframe com as cotações da ação.
print(get_data_history(ticker, period, interval, expiration_seconds))
```

Como manipular esses dados no redis?
---
Enquanto o container estiver de pé, conseguiremos ver esses dados que que estão em memória no redis.

Para acessar os dados de uma determinada ação, rode o comando à seguir:
```terminal
docker exec -it redis redis-cli get VALE3.SA
```

E para apagar todos os dados do redis:
```terminal
docker exec -it redis redis-cli FLUSHDB
```

Esse post faz parte da série "Financial Advisor Bot", mostrando as soluções que estou usando na construção desse "advisor", irei organizar todos os posts dessa série aqui [Financial Advisor Bot](../../tags/financial-advisor-bot/).

[Click aqui para ir para o próximo post.]()