# docker-compose

In this folder you will find an example deployment of the Kopano One container for `docker-compose`, along with a minimal configuration example of the bundled services.

The files in this example should not be used directly, but merely serve as an inspiration.

## Design goals of this project

- configuration via pre-created config files
  - no more auto configuration "magic"
- ability to run all Kopano components in a single container
- use init system in container to easily restart/reload individual services
- healthchecks for container
- Prometheus statistics https://stash.kopano.io/projects/KC/repos/prometheus-kopano-exporter/browse
- use unix sockets wherever possible (database, mta, kopano services itself)
- simple mail setup using KETS for mail handling
- have deployment examples in subfolders (e.g. Univention, Synology, ...)
- tooling for automatic building and deployment

Optional:

- ability to run fetchmail to get mail from existing mailboxes
- have the container running read-only and with minimal capabilities
