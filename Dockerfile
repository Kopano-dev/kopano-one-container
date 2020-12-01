FROM debian:buster as base

ARG KOPANO_ONE_REPOSITORY_URL="https://repo.kopano.com/kopano/one/"
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
    # TODO setting to hold is only to prove that these packages are installed, altough not needed
    apt-mark hold mariadb-server postfix postfix-ldap && \
    # TODO remove pkgProblemResolver after packages dependencies have been fixed
    apt-get -o Debug::pkgProblemResolver=true install --no-install-recommends -y kopano-one-20.09-groupware-packages && \
    #apt-get install -y kopano-one-any-groupware-system-server && \
    #apt-get install -y kopano-one-any-groupware-packages-server && \
    rm -rf /var/cache/apt /var/lib/apt/lists/*

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF
