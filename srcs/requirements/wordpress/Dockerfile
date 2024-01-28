FROM alpine:3.16

RUN apk --update add \
    php8 \
    php8-fpm \
    php8-mysqli \
    php8-json \
    mariadb-client \
    curl \
    && rm -rf /var/cache/apk/*

WORKDIR /var/www/html/wordpress

COPY conf/create_wp.sh /usr/local/bin/create_wp.sh

RUN chmod +x /usr/local/bin/create_wp.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/create_wp.sh"]
