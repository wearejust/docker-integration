include ./Make.config

.DEFAULT_GOAL := help

file := Makefile
makefile_content := $(shell cat ${file})

help:
	@grep -Eh "##" $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' |  sed -e 's/##//'

##
## 🚀  Project setup
##---------------------------------------------------------------------------

.PHONY: start up stop reset

start: 				## Install all assets and build up the environment
start: up web.build db open

up: 				## Boot the docker container
up:             
	$(DC) up -d

stop:         		## Remove docker containers
stop:          
	$(DC) kill
	$(DC) rm -v --force

reset: 				## Reset the whole project
reset:
	stop start

##
## 🏗  Builds
##---------------------------------------------------------------------------
web.base: vendor app/config/parameters.yml

web.build:			## Build the basic application for dev environment.
web.build: web.base assets

web.build-prod: 	## Build the basic application for production.
web.build-prod: web.base assets-prod

##
## 🤖  Symfony console	
##---------------------------------------------------------------------------

.PHONY: cc console

cc: 				## Clear the cache in dev env	
cc: 
	$(RUN) php $(CONSOLE) cache:clear

console: 			## Symfony console php bin with <arguments>
console: 
	$(RUN) php $(CONSOLE) $(ARGUMENTS)

composer: 			## Symfony console php bin with <arguments>
composer: 
	$(RUN) php composer $(ARGUMENTS)


##
## 🗄  Database
##---------------------------------------------------------------------------
db: vendor
	$(RUN) php php -r "for(;;){if(@fsockopen('mysql',3306)){break;}}" # Wait for MySQL
	$(RUN) php $(CONSOLE) doctrine:database:drop --force --if-exists
	$(RUN) php $(CONSOLE) doctrine:database:create --if-not-exists
	$(RUN) php $(CONSOLE) doctrine:migrations:migrate -n

db-diff: vendor
	$(RUN) php $(CONSOLE) doctrine:migration:diff

db-migrate: vendor
	$(RUN) php $(CONSOLE) doctrine:migration:migrate -n

db-rollback: vendor
	$(RUN) php $(CONSOLE) d:m:e --down $(shell $(RUN) php $(CONSOLE) d:m:l) -n


##
## 🗜  Assets
##---------------------------------------------------------------------------

.PHONY: browsersync share open 

browsersync:
	$(call comment "Browsersync not installed now addings.")
	@yarn global add browser-sync

share: browsersync
	$(call success "Running browsersync")

	@browser-sync start --proxy $(call domain) \
	--tunnel \
	--files "public/css/*.css" \
	--files "public/js/*.js" \
	--open "external" \
	-d

yarn.add:
	$(RUN) webpack yarn add $(package)

yarn:
	$(RUN) webpack yarn $(ARGUMENTS)

watch:
	$(RUN) webpack yarn watch

assets:
	$(RUN) webpack yarn build-dev

assets-prod:
	$(RUN) webpack yarn build-prod

open:
	open "http://$(call domain)"


# ✅ File checks
#---------------------------------------------------------------------------
.PHONY: vendor composer_update

app/config/parameters.yml: app/config/parameters.yml.dist
	@$(RUN) php composer run-script post-install-cmd

composer.lock: composer.json
	@echo compose.lock is not up to date.

yarn.lock: package.json
	@$(call error, "yarn.lock is not up to date.")

vendor: composer.lock
	@$(RUN) php composer install

%: 
	@:
