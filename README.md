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
1. You must have github authorization by public key

## Installation

Configure and start dependency services:

```bash
make
```

## Run developing apps

**1st terminal session (peatio)**

```bash
make start_peatio
```

**2nd terminal session (barong)**

```bash
make start_barong
```

**3rd terminal session (baseapp)**

```bash
make start_baseapp
```

**4th terminal session (rango)**

```bash
make start_rango
```

**5th terminal session (liza)**

```bash
make start_liza
```

Open page http://localhost:8080/ in browser.

## Run main apps in light mode (only web, no daemons)

**1st terminal session (peatio)**

```bash
make start_peatio_web
```

**2nd terminal session (barong)**

```bash
make start_barong_web
```

**3rd terminal session (baseapp)**

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

- 8080 - gateway (nginx). It is routing requests to other services
  according to routing table in ambassador-config/mapping-peatio.yaml
- Other ports you can find in ambassador-config/mapping-peatio.yaml

## Common tasks

### Totaly recreate and restart docker containers

```bash
make services
```

### Geth docker container

_see docker-compose-geth.yml_

```
make start_geth
make stop_geth
```

#### Geth console

```
make geth_console
```

## Known issues:

Install gem pg for mac and linux - https://wikimatze.de/installing-postgresql-gem-under-ubuntu-and-mac/

Look into your $PATH

## FAQ

### Troubleshoot

#### Unsupported SSL version on Mac

When you run make, you may encounter the following error:
```
WARNING: /Users/alex/.rvm/rubies/ruby-2.7.5/bin/ruby is loading libcrypto in an unsafe way
zsh: abort      bin/rake db:reset
```

You need to install openssl@1.1 and update the system symlinks.
_(Tested on Mac Intel)_
```bash
brew install openssl@1.1
rm /usr/local/lib/libcrypto.dylib /usr/local/lib/libssl.dylib
sudo ln -s $(brew --prefix openssl@1.1)/lib/libcrypto.dylib /usr/local/lib/
sudo ln -s $(brew --prefix openssl@1.1)/lib/libssl.dylib  /usr/local/lib
```

#### Vault

If you have a problem like:

```
./bin/init_vault
VAULT_TOKEN=
Error disabling secrets engine at secret/: Error making API request.

URL: DELETE http://vault:8200/v1/sys/mounts/secret
Code: 400. Errors:

* missing client token
make: *** [Makefile:56: init_vault] Ошибка 2
```

or another like this. Check your setup direnv.
if this command:

```
env | grep VAULT
```

doesn't show you anything.
Please setup your direnv:
https://clck.ru/XR3pC

#### Rails commands don't work in peatio on macOS

See: https://github.com/se3000/ruby-eth/issues/47

#### Failed to build gem pg

```
checking for pg_config... no
No pg_config... trying anyway. If building fails, please try again with
 --with-pg-config=/path/to/pg_config
checking for libpq-fe.h... no
Can't find the 'libpq-fe.h header
*** extconf.rb failed ***
```

You need to install `libpq`

**MacOs**

```
brew install libpq
```

**Linux**

```
sudo apt-get install libpq-dev
```


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
Member.find_each do |member|
  member.get_account('usd').update_columns balance: 10000, locked: 1000
  member.get_account('btc').update_columns balance: 1, locked: 1
end

```

### How to enable 2FA?

Add to the `.envrc.local`:

```bash
export VAULT_ENABLED=true
```

### .envrc hierarcy

Base environment variables are provided by .envrc file from git repository, local overrides could be stored inside .envrc.local file that is excluded from version control

## TODO

1. On linux add `host.docker.internal` to hosts in docker-compose.yml. Or wait until developers will include it to docker setup. https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal
1. add availability to make withdraw/deposits
1. add testnet node
