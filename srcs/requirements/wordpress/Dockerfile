FROM alpine:3.16

RUN apk update && apk upgrade && apk add --no-cache\
    php8 \
    php8-fpm \
    php8-mysqli \
    php8-json \
    mariadb-client \
    curl \
    && rm -rf /var/cache/apk/*

WORKDIR /var/www/html/wordpress

COPY ./requirements/wordpress/conf/create_wp.sh .

RUN chmod +x ./create_wp.sh

EXPOSE 9000

ENTRYPOINT ["./create_wp.sh"]
