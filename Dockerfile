FROM phusion/baseimage:focal-1.0.0

ARG KOPANO_ONE_REPOSITORY_URL="https://repo.kopano.com/kopano/one"
ARG ONE_VERSION=20.09

ENV \
    DEBIAN_FRONTEND=noninteractive

LABEL maintainer=development@kopano.io \
    org.label-schema.name="Kopano One backend container" \
    org.label-schema.description="Container image for running backend services of Kopano One" \
    org.label-schema.url="https://kopano.com/products/groupware/one/" \
    org.label-schema.vcs-url="https://github.com/Kopano-dev/kopano-one-container" \
    org.label-schema.version=$ONE_VERSION \
    org.label-schema.schema-version="1.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl gnupg2 software-properties-common && \
    curl -fsSL $KOPANO_ONE_REPOSITORY_URL/$ONE_VERSION/gpg | apt-key add - && \
    add-apt-repository "deb $KOPANO_ONE_REPOSITORY_URL/$ONE_VERSION $(lsb_release -cs) supported" && \
    rm -rf /var/cache/apt /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install --no-install-recommends -y kopano-one-$ONE_VERSION && \
    rm -rf /var/cache/apt /var/lib/apt/lists/*

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF