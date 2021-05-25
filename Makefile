dc_mysite = CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose run mysite

.DEFAULT_GOAL := install_generate

FORCE:

clean: FORCE
	@$(dc_mysite) find *.html -delete

install: FORCE
	@$(dc_mysite) bundle install

generate: FORCE
	@$(dc_mysite) bundle exec ruby ./generate.rb

install_generate: install generate

shell: FORCE
	@$(dc_mysite) /bin/sh

up: FORCE
	@docker-compose down
	@docker-compose up -d

preview: FORCE
	@xdg-open  http://localhost:5555

deploy: generate
	@git add .
	@git commit -m "dont know much about history"
	@git push
