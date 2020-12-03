# MariaDB Docker Image

## Socket Authentication (10.5+)
Note: Since version 10.5, MariaDB supports UNIX socket authentication
out-of-the-box. Thus, you can always access the database as `root` user from
the container. There is no reason to limit this, as if you manage to access the
container as `root`, you can anyways do what ever you want for the database.

For more details, please see [MariaDB
documentation](https://mariadb.com/kb/en/authentication-plugin-unix-socket/).

## Variables
 - `MYSQL_ROOT_PASSWORD`: create root user with this password
 - `MYSQL_ALLOW_EMPTY_PASSWORD`: allow creating root user with empty password
 - `MYSQL_RANDOM_ROOT_PASSWORD`: create random password for the root user on first start
 - `MYSQL_INITDB_SKIP_TZINFO`
 - `MYSQL_ROOT_HOST`: from what host root access should be allowed?

### Create database on first start
 - `MYSQL_DATABASE`: name of the password to be created
 - `MYSQL_USER`: username for the new user
 - `MYSQL_PASSWORD`: password for the new user
