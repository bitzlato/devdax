# devdax

DAX от bitzlato (openware) для разработки.

Запускает инфраструктуру: peatio, barong, baseapp, postgresql, vault, redis,
rabbitmq, ambassador в удобном для разработки виде на MacOS и Linux.

## Предварительная настройка окружения

1. Для начала у вас должен быть установлен и настроен direnv, rbenv, nvm, goenv - https://github.com/bitzlato/guides#правильно-настроенное-окружение

2. Должны быть прописаны локальные хосты: `peatio.local ws.local www.app.local` в
   /etc/hosts (для macos это /etc/private/hosts) на сетевой IP-адрес (НЕ
   localhost)

Например

```
192.168.88.251 peatio.local ws.local www.app.local
```

Где 192.168.88.251 это мой сетевой IP-адрес который я узнал через команду:

```bash
ifconfig  | grep inet
```

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
