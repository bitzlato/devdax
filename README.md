# devdax

DAX от bitzlato (openware) для разработки.

Запускает инфраструктуру: peatio, barong, baseapp, postgresql, vault, redis,
rabbitmq, ambassador в удобном для разработки виде на MacOS и Linux.

## Предварительная настройка окружения

Для начала у вас должен быть установлен и настроено https://github.com/bitzlato/guides#правильно-настроенное-окружение

0) docker vs docker-compose
1) direnv
2) rbenv
3) nvm, yarn
4) goenv

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
make start_peatio
```

В окне терминала N2 (barong)

```bash
make start_barong
```

В окне терминала N3 (baseapp)

```bash
make start_baseapp
```

## Куда смотреть как оно работает?

```bash
open http://localhost:8080
```

## Порты:

* 8080 - висит ambasador (gateway) и маршрутиризует запросы на остальные
  сервисы согласно маршрутам прописанным в ambassador-config/mapping-peatio.yaml
* Остальные порты смотри в ambassador-config/mapping-peatio.yaml 

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

1. Для линукс добавлять `host.docker.internal` в хосты в docker-compose.yml. Или дождатья когда они включает этот хост по все поставки докера https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal

