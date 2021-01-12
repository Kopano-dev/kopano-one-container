# Kopano ONE Container

Officially supported container image for [Kopano ONE](https://kopano.com/products/groupware/one/) suitable both for a stand alone installation and distribution through app stores such as the [Univention App Center](https://www.univention.com/products/univention-app-center/app-catalog/?term=kopano). Can only be used with a valid [Kopano ONE subscription](https://kopano.com/pricing/groupware/).

Design goals:

- configuration via pre created config files
- ability to run all Kopano components in a single container
  - with the optional possibility to only start services belonging to a certain class of services (backend vs. frontend)
- use init system in container to easily restart/reload individual services
- optional containers for database, identity management and mta should be provided