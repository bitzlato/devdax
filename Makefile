mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

# TODO check VAULT_TOKEN, JWT_SECERTS and DATABASE_PASSWORD
# TODO check *env
# TODO check hosts

all: setup start

start: deps services configure_apps

setup: .envrc submodules

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
	docker-compose exec influxdb bash -c "cat /influxdb.sql | influx"

deps: GeoLite2-Country.mmdb 
	direnv version
	rbenv version
	rbenv install -s
	pg_config --version || brew install -q libpq
	brew install -q shared-mime-info

submodules:
	git submodule init
	git submodule update

init_vault:
	./bin/init_vault

baseapp_start:
	cd baseapp/web; yarn start -p 3002

peatio_start:
	cd peatio; bundle exec foreman start

barong_start:
	cd barong; bundle exec foreman start

app_baseapp:
	cd baseapp/web; yarn install

app_barong:
	cd barong; rbenv install -s; bundle

app_peatio:
	cd peatio; rbenv install -s; bundle; ./bin/init_config; \
			rm -f log/* log/daemons/*; \
			bin/rake tmp:clear tmp:create; \
			bin/rake db:create db:migrate; \
			bin/rake db:seed

secrets:
	bundle exec peatio security keygen --path=secrets
