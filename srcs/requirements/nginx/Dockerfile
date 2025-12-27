ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y && apt install nginx -y \
	&& apt install openssl

COPY ./config/init_nginx.sh /usr/local/bin/init_nginx.sh
COPY ./config/self-signed.conf /usr/local/bin/self-signed.conf
RUN chmod +x /usr/local/bin/init_nginx.sh

CMD [ "/usr/local/bin/init_nginx.sh" ]
