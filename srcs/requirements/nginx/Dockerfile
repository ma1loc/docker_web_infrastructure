FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install nginx -y \
	&& apt install openssl

# - rsa:2048: algo used to generate (pub/priv)keys
# - keyout: private key
# - out; certifecate(public key)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=MA/ST=Casablanca/L=Casablanca/O=yanflous.42/CN=yanflous.42.fr"

# - ssl_certificate_key | ssl_certificate
COPY ./config/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ./config/ssl-params.conf /etc/nginx/snippets/ssl-params.conf


# - main config includes /etc/nginx/sites-enabled/* to used it in runtime
COPY ./config/nginx.config /etc/nginx/sites-enabled/nginx.config
# - sites-available it's only behave as backup config file.
COPY ./config/nginx.config /etc/nginx/sites-available/nginx.config

# - metadata/documentation, change noting
EXPOSE 443

# Master process
CMD [ "nginx", "-g", "daemon off;" ]
