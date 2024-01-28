#!/bin/sh

mkdir -p /run/mysqld
chmod 0755 /run/mysqld

chmod 0755 /var/lib/mysql
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql

