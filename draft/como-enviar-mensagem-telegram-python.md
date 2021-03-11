---
title: "[Draft] Como enviar mensagens via telegram com python"
description: "[Draft] Como enviar mensagens via telegram com python"
date: "2020-12-26"
categories:
  - "Telegram"
  - "Python"
tags:
  - "Telegram"
  - "Python"
cover:
    image: "https://repository-images.githubusercontent.com/38696925/a761cf00-b652-11ea-881b-09178348f5fd"
    alt: "Python Telegram Bot"
    caption: "Python Telegram Bot"
ShowToc: true
TocOpen: false
---

Como enviar varias fotos agrupadas no telegram?
---

[https://core.telegram.org/bots/api#sendmediagroup](https://core.telegram.org/bots/api#sendmediagroup)

```python
import telegram

class Telebot:
    def __init__(self):
        self.bot_token = 'token_do_seu_bot'
        self.chat_id   = 'id_do_chat'
        self.bot = telegram.Bot(token=self.bot_token)

    def send_photos(self, photos):
        return self.bot.send_media_group(chat_id=self.chat_id, media=photos, disable_notification=True)

files="Arquivos que deseja enviar"
photos=[]

for file in files:
    photos.append(open(file, 'rb'))

if photos:
    Telebot().send_photos(photos)
```

{{< cta "Sign up for free!" "https://sensr.net/auth/users/sign_up" >}}