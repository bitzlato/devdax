mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
PROXY_HOST := "s1.s-www.lgk.one"
UNAME := $(shell uname)

# TODO check VAULT_TOKEN, JWT_SECERTS and DATABASE_PASSWORD
# TODO check *env
# TODO check hosts

all: deps setup services configure_apps

setup: .envrc submodules rbenv nvm
	@echo setup

rbenv:
	rbenv install -s

nvm:
	. ${NVM_DIR}/nvm.sh && nvm install

.envrc:
	direnv allow

configure_apps: app_baseapp app_barong app_peatio app_liza

GeoLite2-Country.mmdb:
ifeq ($(UNAME), Darwin)
		wget -O - https://download.maxmind.com/app/geoip_download\?edition_id\=GeoLite2-Country\&suffix\=tar.gz\&license_key\=T6ElPBlyOOuCyjzw | tar -xz --strip-components 1 "GeoLite2-Country_*/GeoLite2-Country.mmdb"
else
		wget -O - https://download.maxmind.com/app/geoip_download\?edition_id\=GeoLite2-Country\&suffix\=tar.gz\&license_key\=T6ElPBlyOOuCyjzw | tar -xz --strip-components 1 --wildcards "GeoLite2-Country_*/GeoLite2-Country.mmdb"
endif

services: secrets stop_and_remove_services start_services init_vault

stop_and_remove_services:
	docker-compose rm -fsv

start_services:
	docker-compose up -Vd db influxdb redis rabbitmq gateway vault tower
	until $$(curl --output /dev/null --silent --head --fail localhost:8086/ping); do sleep 1; done
	docker-compose exec -T influxdb bash -c "cat /influxdb.sql | influx"

start_geth:
	docker-compose -f docker-compose-geth.yml up -Vd

stop_geth:
	docker-compose -f docker-compose-geth.yml rm -fsv

geth_console:
	geth attach http://localhost:8545

deps: GeoLite2-Country.mmdb
	direnv version
	rbenv -v
ifeq ($(UNAME), Drawin)
	pg_config --version 2&> /dev/null || brew install -q libpq
	brew install -q shared-mime-info
endif

submodules:
	git submodule update --init --recursive

init_vault:
	./bin/init_vault

start_baseapp:
	echo -n -e "\033]0;baseapp\007"
	cd baseapp; PORT=3002 yarn start:all

start_baseapp_proxy:
	echo -n -e "\033]0;baseapp_proxy\007"
	cd baseapp; \
	PORT=8080 PROXY_HOST=$(PROXY_HOST) yarn start

start_peatio:
	echo -n -e "\033]0;peatio\007"
	cd peatio; bundle exec foreman start

start_barong:
	echo -n -e "\033]0;barong\007"
	cd barong; bundle exec foreman start

start_peatio_web:
	echo -n -e "\033]0;peatio_web\007"
	cd peatio; bundle exec foreman start web

start_barong_web:
	echo -n -e "\033]0;barong_web\007"
	cd barong; bundle exec foreman start web

start_rango:
	cd rango; go run ./cmd/rango

start_liza:
	cd liza; bundle exec foreman start

start_belomor:
	docker compose up -V belomor

app_baseapp:
	cd baseapp; yarn rebuild
	rm -f baseapp/web/public/config/env.js; ln -s env.localdev.js baseapp/web/public/config/env.js

app_barong:
	cd barong; rbenv install -s; bundle; ./bin/init_config; \
		bundle exec rake db:create db:migrate; \
		DB=bitzlato bundle exec rake db:create; psql bitzlato_development < db/bitzlato/structure.sql; \
		./bin/rake db:seed; \
		bundle exec rails runner "%w[superadmin admin accountant member].each { |role| Permission.create!(action: 'ACCEPT', role: role, verb: 'ALL', path: 'liza') unless Permission.exists?(role: role, path: 'liza') }"

app_peatio:
	cd peatio; rbenv install -s; bundle; \
			rm -f log/* log/daemons/*; \
			bin/rake tmp:clear tmp:create; \
			bin/rake db:reset

app_liza:
	cd liza; git submodule init; git submodule update; \
		rbenv install -s; bundle; \
		bundle exec rails db:setup; \
		yarn install

secrets:
	bundle exec peatio security keygen --path=secrets
