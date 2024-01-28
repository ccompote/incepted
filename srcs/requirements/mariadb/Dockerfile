FROM alpine:3.16

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./requirements/mariadb/conf/create_db.sh /tmp/create_db.sh

RUN chmod +x /tmp/create_db.sh

CMD ["/bin/sh /tmp/create_db.sh"]
ENTRYPOINT ["tail", "-f",  "/dev/null"]

