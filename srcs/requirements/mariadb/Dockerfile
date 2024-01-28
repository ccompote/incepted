FROM alpine:3.16

RUN apk update && apk add --no-cache mariadb mariadb-client

ENTRYPOINT create_db.sh
