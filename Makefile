mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

# TODO check VAULT_TOKEN, JWT_SECERTS and DATABASE_PASSWORD
#
all: deps GeoLite2-Country.mmdb submodules start_services init_vault install_baseapp install_barong install_peatio

GeoLite2-Country.mmdb:
	wget -O GeoLite2-Country.mmdb https://download.maxmind.com/app/geoip_download\?edition_id\=GeoLite2-Country\&suffix\=tar.gz\&license_key\=T6ElPBlyOOuCyjzw

services: secrets stop_and_remove_services start_services init_vault

stop_and_remove_services:
	docker-compose rm -fsv

start_services:
	docker-compose up -Vd
	docker-compose exec influxdb bash -c "cat peatio/db/influxdb.sql | influx"

deps:
	$(nvm version)
	direnv version
	rbenv version
	rbenv install -s
	brew install -q libpq
	brew install -q shared-mime-info

submodules:
	git submodule init
	git submodule update

install_baseapp:
	cd baseapp/web; yarn install

install_barong:
	cd barong; rbenv install -s; bundle

init_vault:
	./bin/init_vault

install_peatio:
	cd peatio; rbenv install -s; bundle; ./bin/init_config; \
			rm -f log/* log/daemons/*; \
			bin/rake tmp:clear tmp:create; \
			bin/rake db:create db:migrate; \
			bin/rake db:seed

secrets:
		bundle exec peatio security keygen --path=secrets
