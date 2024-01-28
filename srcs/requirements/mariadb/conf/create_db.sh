#!/bin/sh

mkdir -p /run/mysqld
chmod 0755 /run/mysqld

# Check if /var/lib/mysql/mysql exists
if [ ! -d "/var/lib/mysql/mysql" ]; then

    chmod 0755 /var/lib/mysql
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql

    # Set up database with users and admin
    cat > /tmp/mysql_setup.sql <<EOF
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE ${WP_DB_NAME};
CREATE USER '${WP_DB_USR}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USR}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
FLUSH PRIVILEGES;
EOF

    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/mysql_setup.sql
    rm -f /tmp/mysql_setup.sql
fi

# Allow proper ports in mariadb network config
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Exit script with running daemon
exec /usr/bin/mysqld --user=mysql --console
