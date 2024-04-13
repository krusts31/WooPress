#! /bin/sh

systemctl start mariadb
systemctl enable mariadb
set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

#{{{ Functions

# Predicate that returns exit status 0 if the database root password
# is set, a nonzero exit status otherwise.
is_mysql_root_password_set() {
  ! mysqladmin --user=root status > /dev/null 2>&1
}

# Predicate that returns exit status 0 if the mysql(1) command is available,
# nonzero exit status otherwise.
is_mysql_command_available() {
  which mysql > /dev/null 2>&1
}


if ! is_mysql_command_available; then
  echo "The MySQL/MariaDB client mysql(1) is not installed."
  exit 1
fi

if is_mysql_root_password_set; then
  echo "Database root password already set"
  exit 0
fi
mysql --user=root <<_EOF_
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;

CREATE DATABASE ${WORDPRESS_DATABASE_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER ${MARIADB_USER}@'%' IDENTIFIED by '${MARIADB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WORDPRESS_DATABASE_NAME}.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
_EOF_
