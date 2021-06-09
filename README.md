# Kopano ONE Container

Officially supported container image for [Kopano ONE](https://kopano.com/products/groupware/one/) suitable both for a stand alone installation and distribution through app stores such as the [Univention App Center](https://www.univention.com/products/univention-app-center/app-catalog/?term=kopano). Can only be used with a valid [Kopano ONE subscription](https://kopano.com/pricing/groupware/).

## Running this container

This project provides a container image that is self-contained and brings all the needed gear (like user management, database and mail transport) to get going with Kopano One. Running Kopano One in a container is as easy as executing the following command:

```bash
docker run -it -v /tmp/kopano-config:/etc/kopano -v /tmp/kopano-data:/var/lib/kopano -v /tmp/kopano-database:/var/lib/mysql kopano/kopano-one:latest
```

With the above command the container will at startup copy example configuration to `/tmp/kopano-config` which can then be adapted for the local environment.

For more usage examples check the [docs](docs/) folder.

## Using an external database

To disable the built-in database simply create the following file in the container `/etc/service/mariadb/down`. This will prevent the automatic start of the database.
