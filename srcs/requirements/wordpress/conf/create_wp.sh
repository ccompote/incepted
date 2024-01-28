sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php81/php-fpm.d/www.conf

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp-cli.phar

wp-cli.phar cli update --yes --allow-root

wp-cli.phar core download --allow-root

wp-cli.phar config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${DB_HOST} –path=“/var/www/html/wordpress”--allow-root

wp-cli.phar core install --url=${HOSTNAME}/wordpress --title=“Inception”--admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root

wp-cli.phar user create $WP_USER ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=subscriber --display_name=${WP_USER} --porcelain --path=“/var/www/html/wordpress“ --allow-root

exit script with starting php-fpm:
exec /usr/sbin/php-fpm81 -F -R
