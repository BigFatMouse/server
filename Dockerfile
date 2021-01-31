FROM debian:buster
RUN apt-get moo
RUN apt update
RUN apt -y upgrade
RUN apt -y install wget nginx mariadb-server vim openssl
RUN apt -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

WORKDIR /var/www/html/

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
COPY srcs/wp-config.php /var/www/html/wordpress

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.4-english.tar.gz && rm -rf phpMyAdmin-5.0.4-english.tar.gz
RUN mv phpMyAdmin-5.0.4-english phpmyadmin
RUN openssl req -x509 -nodes -days 365 -subj "/C=RU/ST=Kazan/L=Kazan/O=21/OU=mhogg/CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;
COPY srcs/config.inc.php phpmyadmin
COPY srcs/default /etc/nginx/sites-available/default

EXPOSE 80 443

RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*


WORKDIR /
COPY srcs/script.sh /
RUN chmod +x script.sh
CMD bash script.sh

