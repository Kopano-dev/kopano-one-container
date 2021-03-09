# define some defaults https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

docker_repo := kopano

vcs_ref := $(shell git rev-parse --short HEAD)
date := $(shell date '+%Y%m%d%H%M%S')

KOPANO_ONE_REPOSITORY_URL=https://repo.kopano.com/kopano/one
ONE_VERSION=20.09

.PHONY: build
build:
	docker buildx build --platform linux/amd64 --rm \
		--build-arg VCS_REF=$(vcs_ref) \
		--build-arg KOPANO_ONE_REPOSITORY_URL=$(KOPANO_ONE_REPOSITORY_URL) \
		--build-arg ONE_VERSION=$(ONE_VERSION) \
		--cache-from $(docker_repo)/kopano-one:latest \
		-t $(docker_repo)/kopano-one .

.PHONY: build-base
build-base:
	docker build --rm \
		--target base \
		--build-arg VCS_REF=$(vcs_ref) \
		--build-arg KOPANO_ONE_REPOSITORY_URL=$(KOPANO_ONE_REPOSITORY_URL) \
		--build-arg ONE_VERSION=$(ONE_VERSION) \
		--cache-from $(docker_repo)/kopano-one:latest \
		-t $(docker_repo)/kopano-one:base .

.PHONY: build-frontend
build-frontend:
	docker build --rm \
		--target frontend \
		--build-arg VCS_REF=$(vcs_ref) \
		--build-arg KOPANO_ONE_REPOSITORY_URL=$(KOPANO_ONE_REPOSITORY_URL) \
		--build-arg ONE_VERSION=$(ONE_VERSION) \
		--cache-from $(docker_repo)/kopano-one:latest \
		-t $(docker_repo)/kopano-one:frontend .

.PHONY: tag
tag: build
	docker tag $(docker_repo)/kopano-one $(docker_repo)/kopano-one:$(ONE_VERSION)-$(date)

.PHONY: publish
publish: tag
	docker push $(docker_repo)/kopano-one:$(ONE_VERSION)-$(date)
