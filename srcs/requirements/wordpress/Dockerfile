FROM alpine:3.18

RUN apk update && apk upgrade && apk add --no-cache \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-json \
    php81-phar \
    php81-openssl \
    php81-mbstring \
    mariadb-client \
    curl \
    && rm -rf /var/cache/apk/*

WORKDIR /var/www/html/wordpress

COPY ./requirements/wordpress/conf/create_wp.sh /tmp/create_wp.sh

RUN chmod +x /tmp/create_wp.sh

EXPOSE 9000

ENTRYPOINT ["/tmp/create_wp.sh"]
