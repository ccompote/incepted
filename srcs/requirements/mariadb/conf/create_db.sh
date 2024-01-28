#!/bin/sh

chown -R mysql:mysql /var/lib/mysql
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

    sed -i '/\[client-server\]/a\
            port = 3306\n\
            # socket = /run/mysqld/mysqld.sock\n\
            \n\
            !includedir /etc/mysql/conf.d/\n\
            !includedir /etc/mysql/mariadb.conf.d/\n\
            \n\
            [mysqld]\n\
            user = root\n\
            \n\
            [server]\n\
            bind-address = 0.0.0.0' /etc/mysql/my.cnf

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

    /usr/bin/mysqld --user=mysql:mysql --bootstrap < /tmp/mysql_setup.sql
    rm -f /tmp/mysql_setup.sql

sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec /usr/bin/mysqld --user=mysql
