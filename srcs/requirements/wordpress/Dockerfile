FROM debian:bookworm

# > php-fpm: FastCGI process manager
# > php-zip: help to unzip packegs
# > php-mysql help wp make connection wiht mariadb
# > php-curl: help wp curl in the web for fetching
# > php-gd: images processing libaray
# > php-mbstring: utf-8 encoding
# > php-xml: data formating type

RUN apt update -y && apt upgrade -y \
	&& apt install -y curl \
	php-fpm \
	php-zip \
	php-mysql \
	php-curl \
	php-gd \
	php-mbstring \
	php-xml

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

	
COPY ./config/init_wordpress.sh /usr/local/bin/init_wordpress.sh
COPY ./config/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /usr/local/bin/init_wordpress.sh

EXPOSE 9000

CMD [ "/usr/local/bin/init_wordpress.sh" ]
