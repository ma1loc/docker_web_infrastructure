ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y && apt install nginx -y \
	&& apt install openssl

COPY ./config/init_nginx.sh /usr/local/bin/init_nginx.sh
RUN chmod +x /usr/local/bin/init_nginx.sh

COPY ./config/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ./config/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

COPY ./config/yanflous.42.fr /etc/nginx/sites-available/yanflous.42.fr

CMD [ "/usr/local/bin/init_nginx.sh" ]
