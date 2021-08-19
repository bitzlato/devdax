# devdax

DAX (market.bitzlato.com) from bitzlato/openware for development purposes.

It allows you to use all necessary environment in docker-containers (postgresql, vault, redis, rabbitmq, gateway(nginx), rango), meanwhile main packages (peatio, baseapp, barong) running locally with prepared connection to repository and ready for development.

MacOS is supported. Linux is not tested.

## Environments presettings

You should have installed and configured dev environment https://github.com/bitzlato/guides#правильно-настроенное-окружение

1. docker vs docker-compose
1. direnv
1. rbenv
1. nvm, yarn
1. goenv
1. wget

## Installation

Configure and start dependency services on MacOS:

```bash
make
```

on Linux:

```bash
make linux
```

## Run developing apps

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

4th terminal session (rango)

```bash
make start_rango
```

5th terminal session (liza)

```bash
make start_liza
```

6th terminal session (valera)

```bash
make start_valera
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

## Run only web app with proxy

The fastest way to start developing the frontend. Requires only baseapp and working staging server as a backend. The following command will run webpack-dev-server with proxying of API requests to the staging server.

```bash
make start_baseapp_proxy [PROXY_HOST=ex-stage.bitzlato.bz]
```

## How to check it

```bash
open http://localhost:8080/signin/auth0.html
```

## Ports

* 8080 - gateway (nginx). It is routing requests to other services
  according to routing table in ambassador-config/mapping-peatio.yaml
* Other ports you can find in ambassador-config/mapping-peatio.yaml

## Common tasks

### Totaly recreate and restart docker containers

```bash
make services
```

## Known issues:

Install gem pg for mac and linux - https://wikimatze.de/installing-postgresql-gem-under-ubuntu-and-mac/

Look into your $PATH

## FAQ

### Why it is running on localhost:8080 not www.app.local?
app.local is on http by default, but auth0 accepts localhost or https

### How to endable trading?

```bash
cd barong
bundle exec rails c
```
```ruby
User.find_each { |u| u.update_columns level: 3 }
```

### How to top up the balance?

```bash
cd peatio
bundle exec rails c
```
```ruby
Member.find_each { |m| m.get_account('usd').update_columns balance: 10000, locked: 1000 }
```

Top up all balances for all accounts

```ruby
Account.find_each { |a| a.update_columns balance: 10000, locked: 1000 }
```

## TODO

1. On linux add `host.docker.internal` to hosts in docker-compose.yml. Or wait until developers will include it to docker setup. https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal
1. add tower
1. add availability to make withdraw/deposits
1. add testnet node
1. Add peatio creadentials for valera accounts
