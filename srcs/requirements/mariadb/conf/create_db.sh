#!/bin/sh

echo "[DB config] Configuring MariaDB..."

mkdir -p /run/mysqld 
chown -R mysql:mysql /var/lib/mysql

if [ -d "/var/lib/mysql/mysql" ]
then
    echo "[DB config] MariaDB already configured."
else
    echo "[DB config] Installing MySQL Data Directory..."
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql
    echo "[DB config] MySQL Data Directory done."

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

echo "[DB config] Allowing remote connections to MariaDB"
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "[DB config] Starting MariaDB daemon on port 3306."
exec /usr/bin/mysqld --user=mysql --console
