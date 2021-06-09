# Configure Kopano One Container

The Kopano One container is based on [baseimage-docker](https://github.com/phusion/baseimage-docker) by [Phusion](http://www.phusion.nl/).

## Creating users 

This container uses kidm for user management. At this point in time kidm only has a command line interface. 

##### Add new users using the `gen newusers` command

Kidmd provides a way to create ldif data for new users using a batch mode similar to the unix `newusers` command using the following standard password file format:

```
uid:userPassword:uidNumber:gidNumber:cn,[mail][,kopanoAliases...]:ignored:ignored
```

For example, like this:

```
cat <<EOF | kopano-kidmd gen newusers - --min-password-strength=4 > /etc/kopano/kidm/ldif/main.d/50-users.ldif
jonas:passwordOfJonas123:::Jonas Brekke,jonas@kopano.local::
timmothy:passwordOfTimmothy456:::Timmothy Schöwalter::
EOF
```

This outputs an LDIF template file which you can modify as needed. When done `service restart kopano-kidmd` to make the new users available. Keep in mind that some of the attributes must be unique.

### Quick start with demo users

To add the standard Kopano demo users use the following command (you might want to remove existing ldif configuration with `rm /etc/kopano/kidm/ldif/main.d/*.ldif` before generating the demo users to avoid conflicts).

```bash
/usr/share/kopano-kidmd/generate-demo-users-ldif > /etc/kopano/kidm/ldif/main.d/10-main.ldif
```

This script generates a ldif template, which uses the global configuration values for base DN and mail domain automatically.

Demo users all have a password that is identical to the username, e.g. the password for `user1` is `user1`. The user `user23` is setup to be an admin within Kopano.

## Database

The bundled database is initialised with a random root password and preconfigured to allow the user `kopano` passwordless access to the database `kopano` through the unix socket.

The generated password is printed during the initial start of the container:

```bash
kopano-one_1  | xxxx-xx-xx xx:xx:xx+00:00 [Note] [Entrypoint]: GENERATED ROOT PASSWORD: f#bZq<8gCLR~:1I#QQ!EQM77|-[nR^W=
kopano-one_1  |
kopano-one_1  | xxxx-xx-xx xx:xx:xx+00:00 [Note] [Entrypoint]: /usr/local/bin/mariadb-entrypoint.sh: running /docker-entrypoint-initdb.d/kopano-user.sql
```

### Database backup

TODO the below commands gives an access denied error
```
mysqldump --user=kopano --protocol=socket -S /var/run/mysqld/mysqld.sock kopano
```

### Disabling startup of the bundled database

To prevent the MariaDB service from starting with the container simply create an empty file called `/etc/service/mariadb/down`.

Example:

```Dockerfile
FROM kopano/kopano-one:latest
RUN touch /etc/service/mariadb/down
```

## Prevent individual services from starting

This container image uses `runit`/`runsv` for process managment. To prevent a given service from starting at container startup, simply create an empty file called `down` in `/etc/service/<name-of-service>`.

Read more about runit at [runit - a UNIX init scheme with service supervision](http://smarden.org/runit/).