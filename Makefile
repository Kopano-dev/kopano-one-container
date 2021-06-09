# define some defaults https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DOCKER_REPO := kopano

VCS_REF := $(shell git rev-parse --short HEAD)
TAG := $(shell date '+%Y%m%d%H%M%S')

KOPANO_ONE_REPOSITORY_URL=https://repo.kopano.com/kopano/one
ONE_VERSION=20.09

.PHONY: build
build:
	docker buildx build --platform linux/amd64 --rm \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg KOPANO_ONE_REPOSITORY_URL=$(KOPANO_ONE_REPOSITORY_URL) \
		--build-arg ONE_VERSION=$(ONE_VERSION) \
		-t $(DOCKER_REPO)/kopano-one .

.PHONY: test
test:
	docker-compose -f docs/docker-compose/docker-compose.yml up

.PHONY: test-clean
test-clean:
	docker-compose -f docs/docker-compose/docker-compose.yml down -v

.PHONY: test-enter
test-enter:
	docker-compose -f docs/docker-compose/docker-compose.yml exec kopano-one bash

.PHONY: tag
tag: build
	docker tag $(DOCKER_REPO)/kopano-one $(DOCKER_REPO)/kopano-one:$(ONE_VERSION)-$(TAG)

.PHONY: publish
publish: tag
	docker push $(DOCKER_REPO)/kopano-one:$(ONE_VERSION)-$(TAG)
