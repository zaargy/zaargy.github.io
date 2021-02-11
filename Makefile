run_with_dc = CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose run mysite

.DEFAULT_GOAL := install_generate

FORCE:

clean: FORCE
	@$(run_with_dc) find *.html -delete
	
install: FORCE
	@$(run_with_dc) bundle install

generate: FORCE
	@$(run_with_dc) bundle exec ruby ./generate.rb

install_generate: install generate

shell: FORCE
	@$(run_with_dc) /bin/sh
