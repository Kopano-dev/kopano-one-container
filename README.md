# Kopano ONE Container

Officially supported container image for [Kopano ONE](https://kopano.com/products/groupware/one/) suitable both for a stand alone installation and distribution through app stores such as the [Univention App Center](https://www.univention.com/products/univention-app-center/app-catalog/?term=kopano). Can only be used with a valid [Kopano ONE subscription](https://kopano.com/pricing/groupware/).

## Running this container

This project provides a container image that is self-contained and brings all the needed gear (like user management, database and mail transport) to get going with Kopano One. Running Kopano One in a container is as easy as executing the following command:

```bash
docker run -it -v /tmp/kopano-config:/etc/kopano -v /tmp/kopano-data:/var/lib/kopano -v /tmp/kopano-database:/var/lib/mysql kopano/kopano-one:latest
```

With the above command the container will at startup copy example configuration to `/tmp/kopano-config` which can then be adapted for the local environment.

## Using an external database

To disable the built-in database simply create the following file in the container `/etc/service/mariadb/down`. This will prevent the automatic start of the database.

## Design goals

- configuration via pre-created config files
  - no more auto configuration "magic"
- ability to run all Kopano components in a single container
- use init system in container to easily restart/reload individual services
- optional containers for database, identity management and mta should be provided
- healthchecks for container
- Prometheus statistics https://stash.kopano.io/projects/KC/repos/prometheus-kopano-exporter/browse
- have the container running read-only and with minimal capabilities
- use unix sockets wherever possible (database, mta, kopano services itself)
- ~~simple mail container with optional spam/av (rspamd)~~
  - ~~haraka instead of postfix?~~
    - to simplify the setup the container is using KETS for mail handling
  - mail container should have fetchmail
- have deployment examples in subfolders (e.g. Univention, Synology, ...)
  - Kubernetes Operator
- tooling for automatic building and deployment
