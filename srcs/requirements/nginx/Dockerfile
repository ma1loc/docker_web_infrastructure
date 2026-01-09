FROM debian:bookworm

# -> "X.509” is a public key infrastructure -> make a self-signed certificate
#		certificate signing request (CSR) management

# -> "-nodes" This tells OpenSSL to skip the option to secure our 
# 		certificate with a passphrase.

# -> "-days 365" life time of the cert

# -> "-newkey rsa:2048" This specifies that we want to generate a new 
# 		certificate and a new key at the same time

# -> "-keyout" path of the privet key generated
# -> "-out" path of the cert generated
# NOTE: path of the output will be in '/etc/ssl'

RUN apt update -y && apt upgrade -y && apt install nginx -y \
	&& apt install openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=MA/ST=Casablanca/L=Casablanca/O=yanflous.42/CN=yanflous.42.fr"

COPY ./config/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ./config/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
COPY ./config/yanflous.42.fr /etc/nginx/sites-available/yanflous.42.fr
COPY ./config/yanflous.42.fr /etc/nginx/sites-enabled/yanflous.42.fr

CMD [ "nginx", "-g", "daemon off;" ]
