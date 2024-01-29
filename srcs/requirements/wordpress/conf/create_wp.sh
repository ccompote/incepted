#!/bin/sh

sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php8/php-fpm.d/www.conf

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp-cli.phar

wp-cli.phar cli update --yes --allow-root

wp-cli.phar core download --allow-root

wp-cli.phar core install --url="$HOSTNAME" --title="Inception" --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL" --allow-root

wp-cli.phar config create --dbname="$WP_DB_NAME" --dbuser="$WP_DB_USR" --dbpass="$WP_DB_PASS" --dbhost="$DB_HOSTNAME" --allow-root

wp-cli.phar user create "$WP_USR" "$WP_USR_EMAIL" --user_pass="$WP_USR_PASS" --role=subscriber --display_name="$WP_USR" --allow-root

exec /usr/sbin/php-fpm8 -F -R
