#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
#*	 																				 *#
#*     _ (`-.              ('-. .-. .-')    .-')      ('-.  _  .-')        (`-.   	 *#
#*    ( (OO  )           _(  OO)\  ( OO )  ( OO ).  _(  OO)( \( -O )     _(OO  )_ 	 *#
#*   _.`     \ ,--.     (,------.;-----.\ (_)---\_)(,------.,------. ,--(_/   ,. \	 *#
#*  (__...--'' |  |.-')  |  .---'| .-.  | /    _ |  |  .---'|   /`. '\   \   /(__/	 *#
#*   |  /  | | |  | OO ) |  |    | '-' /_)\  :` `.  |  |    |  /  | | \   \ /   / 	 *#
#*   |  |_.' | |  |`-' |(|  '--. | .-. `.  '..`''.)(|  '--. |  |_.' |  \   '   /, 	 *#
#*   |  .___.'(|  '---.' |  .--' | |  \  |.-._)   \ |  .--' |  .  '.'   \     /__)	 *#
#*   |  |      |      |  |  `---.| '--'  /\       / |  `---.|  |\  \     \   /    	 *#
#*   `--'      `------'  `------'`------'  `-----'  `------'`--' '--'     `-'     	 *#
#*																					 *#
#* 									MADE BY											 *#
#* 		—————————————————————————————————————————————————————————————————————		 *#
#*				 Alpha_1337k       |    https://github.com/Alpha1337k				 *#
#*				 VictorTennekes    |    https://github.com/VictorTennekes			 *#
#*				 Kingmar	 	   |    https://github.com/K1ngmar					 *#
#*																					 *#
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *#

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
	php-cgi \
	php-mbstring \
	wget \
	libnss3-tools \
	sudo \
	make \
	clang

#installing phpMyAdmin
RUN	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64

RUN tar -zxvf phpMyAdmin-5.0.1-english.tar.gz
RUN mkdir html/ && \
	mv phpMyAdmin-5.0.1-english /html/phpMyAdmin

#make plebserv and copy
COPY Plebserv/ Plebserv/
RUN	cd Plebserv && \
	make && \
	mv plebserv ../

#copy directories
COPY /srcs/config/plebfig.conf .
COPY /srcs/phpMyAdmin_config/config.inc.php /tmp/
COPY /srcs/phpMyAdmin_config/phpMyAdmin.conf /tmp/

#config files
RUN mv /tmp/config.inc.php /html/phpMyAdmin/

#certificate
RUN mv mkcert /tmp/ && \
	chmod +x /tmp/mkcert && \
	/tmp/mkcert -install && \
	/tmp/mkcert localhost && \
	mv localhost.pem /tmp/ && \
	mv localhost-key.pem /tmp/

#creating phpMyAdmin user
RUN service mysql start && \
	mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';" && \
	mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost';" && \
	mysql -e "FLUSH PRIVILEGES;"

#creating database
RUN service mysql start && \
	mysql -e "CREATE database wordpress;" && \
	mysql -e "GRANT ALL PRIVILEGES ON wordpress.* to 'admin'@'localhost';" && \
	mysql -e "FLUSH PRIVILEGES;"

#creating a sudo user
RUN adduser --disabled-password -gecos "" admin && \
	sudo adduser admin sudo

#installing wordpress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp/

COPY /srcs/wordpress/wp-config.php /tmp/
COPY /srcs/wp-cli/wp-cli.phar /tmp/
RUN	tar xzf /tmp/latest.tar.gz --strip-components=1 -C /html/ && \
	chmod +x /tmp/wp-cli.phar && \
	chown admin -R /html && \
	mv /tmp/wp-config.php /html/ && \
	mv /tmp/wp-cli.phar /usr/local/bin/wp && \
	service mysql restart && \
	sudo -u admin -i \
	wp core install \
	--url=localhost \
	--path=/html/ \
	--title=Wordpress \
	--admin_user=admin \
	--admin_password=admin \
	--admin_email=admin@mail.nl \
	--skip-email && \
	chown www-data -R /html

#create tmp directory in phpMyAdmin
RUN mkdir /html/phpMyAdmin/tmp
RUN chmod 755 /html/phpMyAdmin/tmp
RUN chown -R www-data:www-data /html/phpMyAdmin

EXPOSE 80

CMD service php7.3-fpm start && \
	service mysql start && \
	./plebserv plebfig.conf
