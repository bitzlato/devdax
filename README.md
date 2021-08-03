# devdax

DAX от bitzlato (openware) для разработки.

Запускает инфраструктуру: peatio, barong, baseapp, postgresql, vault, redis,
rabbitmq, ambassador в удобном для разработки виде на MacOS и Linux.

## Предварительная настройка окружения

Для начала у вас должен быть установлен и настроен direnv, rbenv, nvm, goenv - https://github.com/bitzlato/guides#правильно-настроенное-окружение

## Установка

Запускаете автоматическое развертывание сервисов:

```bash
rbenv install -s
nvm install
make setup
make start
```

## Запуск основных приложений

В окне терминала N1 (peatio)

```bash
make peatio_start
```

В окне терминала N2 (barong)

```bash
make barong_start
```

В окне терминала N3 (baseapp)

```bash
make baseapp_start
```

## Куда смотреть как оно работает?

Заходите в браузер http://www.app.local:8080

## Порты:

* 8080 - висит ambasador (gateway) и маршрутиризует запросы на остальные
  сервисы согласно маршрутам прописанным в ambassador-config/mapping-peatio.yaml
* 

## Common tasks:

# Totaly recreate and restart docker containers:

```bash
make services
```

## Known issues:

Install gem pg for mac and linux - https://wikimatze.de/installing-postgresql-gem-under-ubuntu-and-mac/

Look into your $PATH


## FAQ

1. Почему идем на localhost:8080 а не на www.app.local?

> app.local по умолчанию был на http, а auth0 принимает либо localhost либо https


## TODO 

1. Для линукс прописывать host.docker.internal в docker-compose.yml

