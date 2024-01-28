#!/bin/sh

echo "[DB config] Configuring MariaDB..."

if [ ! -d "/run/mysqld" ]; then
	echo "[DB config] Granting MariaDB daemon run permissions..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d "/var/lib/mysql/wordpress" ]
then
	echo "[DB config] MariaDB already configured."
else
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

	echo "[DB config] Configuring MySQL..."
	TMP=/tmp/.tmpfile

	echo "USE mysql;" > ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}
	echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
	echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
	echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
	echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOTPASS}';" >> ${TMP}
	echo "CREATE DATABASE ${WP_DB_NAME};" >> ${TMP}
	echo "CREATE USER '${WP_DB_USR}'@'%' IDENTIFIED BY '${WP_DB_PASS}';" >> ${TMP}
	echo "GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USR}'@'%' IDENTIFIED BY '${WP_DB_PASS}';" >> ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}


	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
	rm -f ${TMP}
	echo "[DB config] MySQL configuration done."
fi
