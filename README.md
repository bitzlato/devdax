# devdax

DAX (market.bitzlatl.bz) from bitzlato/openware for development purposes.

It allows you to use all necessary environment in docker-containers (postgresql, vault, redis, rabbitmq, gateway(nginx), rango), meanwhile main packages (peatio, baseapp, barong) running locally with prepared connection to repository and ready for development.

MacOS is supported. Linux is not tested.

## Environments presettings

You should have installed and configured dev environment https://github.com/bitzlato/guides#правильно-настроенное-окружение

0. docker vs docker-compose
1. direnv
2. rbenv
3. nvm, yarn
4. goenv
5. wget


## Installation

Get submodules
```bash
git submodule update --init --recursive
```

Configure and start full infra:

```bash
make setup
make start
```

## Run main apps

1st terminal session (peatio)

```bash
make start_peatio
```

2nd terminal session (barong)

```bash
make start_barong
```

3rd terminal session (baseapp)

```bash
make start_baseapp
```

## Run main apps in light mode (only web, no daemons)

1st terminal session (peatio)

```bash
make start_peatio_web
```

2nd terminal session (barong)

```bash
make start_barong_web
```

3rd terminal session (baseapp)

```bash
make start_baseapp
```

## How to check it

```bash
open http://localhost:8080/signin/auth0.html
```

## Ports:

* 8080 - gateway (nginx). It is routing requests to other services
  according to routing table in ambassador-config/mapping-peatio.yaml
* Other ports you can find in ambassador-config/mapping-peatio.yaml 

## Common tasks:

# Totaly recreate and restart docker containers:

```bash
make services
```

## Known issues:

Install gem pg for mac and linux - https://wikimatze.de/installing-postgresql-gem-under-ubuntu-and-mac/

Look into your $PATH

## FAQ

1. Why it is running on localhost:8080 not www.app.local?

> app.local is on http by default, but auth0 accepts localhost or https

## TODO

1. On linux add `host.docker.internal` to hosts in docker-compose.yml. Or wait until developers will include it to docker setup. https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal
2. add market making (valera)
3. add liza
4. add tower
5. add availability to make withdraw/deposits
6. add testnet node
