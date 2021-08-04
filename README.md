# devdax

DAX (market.bitzlatl.bz) introduced by bitzlato/openware for development purposes.

Deploys all neccessary infra parts in containers (postgresql, vault, redis, rabbitmq, gateway(nginx), rango), at the same time basic projects (peatio, baseapp, barong) deploys locally as submodules, binded to repositories and ready to use.

MacOS is supported. Linux is not tested.

## Initial environment setup

You are expected to have the following installed and configured: https://github.com/bitzlato/guides#правильно-настроенное-окружение

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

Run services auto-deploy as follows:

```bash
make setup
make start
```

## Run basic apps (don't confuse with Baseapp application only)

Have 3 instances of terminals running mentioned as respectively:
- N1 - peatio
- N2 - barong
- N3 - baseapp

In N1 terminal console (peatio) run

```bash
make start_peatio
```

In N2 terminal console (barong) run

```bash
make start_barong
```

In N3 terminal console (baseapp) run

```bash
make start_baseapp
```

## Check if infra is running

```bash
open http://localhost:8080
```

## Ports:

* 8080 - ambasador (gateway) listens the port and proxies requests to other parts of infra.
  Proxying is performed according to routes specified in `ambassador-config/mapping-peatio.yaml`
* Please check the rest of the ports in `ambassador-config/mapping-peatio.yaml` 

## Common tasks:

# Totaly recreate and restart docker containers:

```bash
make services
```

## Known issues:

Install gem pg for mac and linux - https://wikimatze.de/installing-postgresql-gem-under-ubuntu-and-mac/

Look into your $PATH

## FAQ

1. Why do we listen on `localhost:8080` not `www.app.local`?

> app.local by default was on http, but auth0 accepts only localhost or https

## TODO

1. On Linux, either do list `host.docker.internal` within hosts of `docker-compose.yml`. Or keep standing by for them to include this host to all releases of docker https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal
2. add market making (valera)
3. add liza
4. add tower
5. add availability to make withdraw/deposits
6. add testnet node
