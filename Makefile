mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

# TODO check VAULT_TOKEN, JWT_SECERTS and DATABASE_PASSWORD
# TODO check *env
# TODO check hosts

all: deps setup start

start: services configure_apps

setup: .envrc submodules rbenv nvm

rbenv:
	rbenv install -s

nvm:
	. ${NVM_DIR}/nvm.sh && nvm install

.envrc:
	ln -s .envrc-example .envrc
	direnv allow

configure_apps: app_baseapp app_barong app_peatio

GeoLite2-Country.mmdb:
	wget -O GeoLite2-Country.mmdb https://download.maxmind.com/app/geoip_download\?edition_id\=GeoLite2-Country\&suffix\=tar.gz\&license_key\=T6ElPBlyOOuCyjzw

services: secrets stop_and_remove_services start_services init_vault

stop_and_remove_services:
	docker-compose rm -fsv

start_services:
	docker-compose up -Vd
	until $$(curl --output /dev/null --silent --head --fail localhost:8086/ping); do sleep 1; done
	docker-compose exec influxdb bash -c "cat /influxdb.sql | influx"

deps: GeoLite2-Country.mmdb
	direnv version
	rbenv version
	rbenv install -s
	pg_config --version 2&> /dev/null || brew install -q libpq
	brew install -q shared-mime-info

submodules:
	git submodule init
	git submodule update

init_vault:
	./bin/init_vault

start_light:
		start_baseapp:
			cd baseapp/web; PORT=3002 yarn start

start_baseapp:
	cd baseapp/web; PORT=3002 yarn start

start_peatio:
	cd peatio; bundle exec foreman start

start_barong:
	cd barong; bundle exec foreman start

start_peatio_web:
	cd peatio; bundle exec foreman start web

start_barong_web:
	cd barong; bundle exec foreman start web

app_baseapp:
	cd baseapp/web; yarn install
	rm -f baseapp/web/public/config/env.js; ln -s env.localdev.js baseapp/web/public/config/env.js

app_barong:
	cd barong; rbenv install -s; bundle; ./bin/init_config; \
	bundle exec rake db:create db:migrate; \
	DB=bitzlato bundle exec rake db:create db:migrate; \
  ./bin/rake db:seed

app_peatio:
	cd peatio; rbenv install -s; bundle; ./bin/init_config; \
			rm -f log/* log/daemons/*; \
			bin/rake tmp:clear tmp:create; \
			bin/rake db:create db:migrate; \
			bin/rake db:seed

secrets:
	bundle exec peatio security keygen --path=secrets
