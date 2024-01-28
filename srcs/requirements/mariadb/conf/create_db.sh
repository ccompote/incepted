#!/bin/sh

	echo "[DB config] Configuring MySQL..."
 
	/usr/bin/mysql --user=root <<SQL_COMMANDS
	USE mysql;
	FLUSH PRIVILEGES;
	DELETE FROM mysql.user WHERE User='';
	DROP DATABASE IF EXISTS test;
	DELETE FROM mysql.db WHERE Db='test';
	DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOTPASS}';
	CREATE DATABASE ${WP_DB_NAME};
	CREATE USER '${WP_DB_USR}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
	GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USR}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
	FLUSH PRIVILEGES;
	SQL_COMMANDS

	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
	rm -f ${TMP}
	echo "[DB config] MySQL configuration done."
