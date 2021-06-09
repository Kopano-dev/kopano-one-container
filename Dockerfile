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

EXPOSE 9080 9443

VOLUME ["/etc/kopano/", "/var/lib/mysql/", "/var/lib/kopano/"]

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl gnupg2 pwgen software-properties-common && \
    curl -fsSL $KOPANO_ONE_REPOSITORY_URL/$ONE_VERSION/gpg | apt-key add - && \
    add-apt-repository "deb $KOPANO_ONE_REPOSITORY_URL/$ONE_VERSION $(lsb_release -cs) supported" && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    rm -rf /var/cache/apt /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install --no-install-recommends -y kopano-one-$ONE_VERSION kopano-smtpstd kopano-kidmd && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* && \
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql&& \
	mkdir -p /var/lib/mysql&& \
	chown -R mysql:mysql /var/lib/mysql&& \
# comment out a few problematic configuration values
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log|user\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log|user\s)/#&/'&& \
# don't reverse lookup hostnames, they are usually another container
	echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

# retrieve mariadb entrypoint
RUN curl -o /usr/local/bin/mariadb-entrypoint.sh https://raw.githubusercontent.com/MariaDB/mariadb-docker/76ead913384ec7dbb66518999bdf522942f15582/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/mariadb-entrypoint.sh && \
    ln -sf $(which setuser) /usr/local/bin/gosu

# copy original config files to a backup location
# so they are still available when /etc/kopano/ gets mounted from the host
RUN cp -r /etc/kopano /etc/kopano.in

# add basic configuration
ADD configuration/kopano-db-access.sql /docker-entrypoint-initdb.d/
ADD configuration/kopano-sync /etc/cron.hourly
ADD configuration/kopano-soft-delete /etc/cron.daily

ADD runit /etc/service

WORKDIR /etc/kopano

# explicitly set init script of base image
CMD ["/sbin/my_init"]

HEALTHCHECK CMD sv status /etc/service/*

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF
