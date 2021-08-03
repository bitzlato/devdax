mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

# TODO check VAULT_TOKEN, JWT_SECERTS and DATABASE_PASSWORD
#
all: deps GeoLite2-Country.mmdb submodules install_baseapp install_barong install_peatio start_services

GeoLite2-Country.mmdb:
	wget -O GeoLite2-Country.mmdb https://download.maxmind.com/app/geoip_download\?edition_id\=GeoLite2-Country\&suffix\=tar.gz\&license_key\=T6ElPBlyOOuCyjzw

start_services:
	docker-compose up -Vd
	docker-compose exec influxdb bash -c "cat peatio/influxdb.sql | influx"

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
	cd baseapp/web
	yarn install
	cd $(root)

install_barong:
	cd barong; rbenv install -s; bundle
	pwd
	cd $(root)

install_peatio:
	cd peatio
	rbenv install -s
	bundle
	./bin/init_config
	rm -f log/* log/daemons/*
	bin/rake tmp:clear tmp:create
	bundle exec peatio security keygen --path=config/secrets
	bin/init_vault
	bin/rake db:create db:migrate; bin/rake db:seed
	cd $(root)
