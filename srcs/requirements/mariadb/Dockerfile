FROM alpine:3.16

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN pwd

COPY requirements/mariadb/conf/create_db.sh /usr/local/bin/create_db.sh

RUN chmod +x /usr/local/bin/create_db.sh

ENTRYPOINT ["/usr/local/bin/create_db.sh"]
