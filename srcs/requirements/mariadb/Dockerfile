FROM alpine:3.16

RUN apk update && apk add --no-cache mariadb mariadb-client


RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

COPY ./requirements/mariadb/conf/create_db.sh /tmp/create_db.sh
RUN chmod +x /tmp/create_db.sh
RUN sh /tmp/create_db.sh && rm create_db.sh

ENTRYPOINT ["/usr/bin/mysqld", "--user=mysql", "--console"]
