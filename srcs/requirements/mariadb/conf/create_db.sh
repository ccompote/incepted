#!/bin/sh


	echo "[DB config] Configuring MySQL..."
	TMP=/tmp/.tmpfile

	echo "USE mysql;" > ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}
	echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
	echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
	echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
	echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';" >> ${TMP}
	echo "CREATE DATABASE $WP_DB_NAME;" >> ${TMP}
	echo "CREATE USER '$WP_DB_USR'@'%' IDENTIFIED BY '$WP_DB_PASS';" >> ${TMP}
	echo "GRANT ALL PRIVILEGES ON *.* TO '$WP_DB_USR'@'%' IDENTIFIED BY '$WP_DB_PASS';" >> ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}

	# Alpine does not come with service or rc-service,
	# so we cannot use: service mysql start
	# We might be able to install with: apk add openrc
	# But we can also manually start and configure the mysql daemon:
	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
	rm -f ${TMP}
	echo "[DB config] MySQL configuration done."

exec /usr/bin/mysqld --user=mysql --console
