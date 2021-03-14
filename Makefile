SHELL := /bin/bash

.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

dev-reset-db:
	bundle exec rails db:drop db:setup db:migrate

install:
	bundle install
	bundle exec rails db:setup db:migrate

run:
	bundle exec rails server

rspec:
	bundle exec rspec
