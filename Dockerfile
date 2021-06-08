# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ikole <ikole@student.codam.nl>               +#+                      #
#                                                    +#+                       #
#    Created: 2020/01/15 15:03:16 by ikole         #+#    #+#                  #
#    Updated: 2021/06/08 13:05:50 by ingmar        ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update && \
	apt-get upgrade -y
	
RUN apt-get install	-y \
	mariadb-server \
	mariadb-client \
	php7.3 \
	php7.3-fpm \
	php7.3-mysql \
	php-common \
	php7.3-cli \
	php7.3-common \
	php7.3-json \
	php7.3-opcache \
	php7.3-readline \
	php-gd \
	php-mbstring \
	wget \
	libnss3-tools \
	sudo

#installing phpMyAdmin
RUN	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gz
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64

RUN tar -zxvf phpMyAdmin-4.9.4-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.4-all-languages /var/www/html/phpMyAdmin


#copy directories
COPY /srcs/nginx/nginx.conf /tmp/
COPY /srcs/phpMyAdmin_config/config.inc.php /tmp/
COPY /srcs/phpMyAdmin_config/phpMyAdmin.conf /tmp/

#config files
RUN mv /tmp/nginx.conf /etc/nginx/sites-available/default
RUN mv /tmp/config.inc.php /var/www/html/phpMyAdmin/
RUN mv /tmp/phpMyAdmin.conf /etc/nginx/conf.d/

#certificate
RUN mv mkcert /tmp/ && \
	chmod +x /tmp/mkcert && \
	/tmp/mkcert -install && \
	/tmp/mkcert localhost && \
	mv localhost.pem /tmp/ && \
	mv localhost-key.pem /tmp/

#creating phpMyAdmin user
RUN service mysql start && \
	mysql -e "CREATE USER 'ikole'@'localhost' IDENTIFIED BY 'fluffy';" && \
	mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'ikole'@'localhost';" && \
	mysql -e "FLUSH PRIVILEGES;"

#creating database
RUN service mysql start && \
	mysql -e "CREATE database wordpress;" && \
	mysql -e "GRANT ALL PRIVILEGES ON wordpress.* to 'ikole'@'localhost';" && \
	mysql -e "FLUSH PRIVILEGES;"

#creating a sudo user
RUN adduser --disabled-password -gecos "" ikole && \
	sudo adduser ikole sudo

#installing wordpress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp/

COPY /srcs/wordpress/wp-config.php /tmp/
COPY /srcs/wp-cli/wp-cli.phar /tmp/
RUN	tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/ && \
	chmod +x /tmp/wp-cli.phar && \
	chown ikole -R /var/www && \
	mv /tmp/wp-config.php /var/www/html/ && \
	mv /tmp/wp-cli.phar /usr/local/bin/wp && \
	service mysql restart && \
	sudo -u ikole -i \
	wp core install \
	--url=localhost \
	--path=/var/www/html/ \
	--title=Wordpress \
	--admin_user=ikole \
	--admin_password=fluffy \
	--admin_email=ikole@student.codam.nl \
	--skip-email && \
	rm -rf var/www/html/index.nginx-debian.html && \
	chmod 777 /var/www/html/wp-content/uploads/2020/01 && \
	chown www-data -R /var/www

#create tmp directory in phpMyAdmin
RUN mkdir /var/www/html/phpMyAdmin/tmp
RUN chmod 755 /var/www/html/phpMyAdmin/tmp
RUN chown -R www-data:www-data /var/www/html/phpMyAdmin

EXPOSE 80
EXPOSE 443

CMD service php7.3-fpm start && \
	service mysql start && \
	./plebserv src/config/plebfig.conf
