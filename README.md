# Kopano ONE Container

Officially supported container image for [Kopano ONE](https://kopano.com/products/groupware/one/) suitable both for a stand alone installation and distribution through app stores such as the [Univention App Center](https://www.univention.com/products/univention-app-center/app-catalog/?term=kopano). Can only be used with a valid [Kopano ONE subscription](https://kopano.com/pricing/groupware/).

Design goals:

- configuration via pre-created config files
  - no more auto configuration "magic"
- ability to run all Kopano components in a single container
  - with the optional possibility to only start services belonging to a certain class of services (backend vs. frontend)
- use init system in container to easily restart/reload individual services
- optional containers for database, identity management and mta should be provided
- healthchecks for container
- Prometheus statistics https://stash.kopano.io/projects/KC/repos/prometheus-kopano-exporter/browse
- have the container running read-only and with minimal capabilities
- use unix sockets wherever possible (database, mta, kopano services itself)
- simple mail container with optional spam/av (rspamd)
  - haraka instead of postfix?
  - mail container should have fetchmail
- have deployment examples in subfolders (e.g. Univention, Synology, ...)
  - Kubernetes Operator
- tooling for automatic building and deployment
