#!/bin/bash

set -e

# -> "X.509” is a public key infrastructure -> make a self-signed certificate
#		certificate signing request (CSR) management

# -> "-nodes" This tells OpenSSL to skip the option to secure our 
# 		certificate with a passphrase.

# -> "-days 365" life time of the cert

# -> "-newkey rsa:2048" This specifies that we want to generate a new 
# 		certificate and a new key at the same time

# -> "-keyout" path of the privet key generated
# -> "-out" path of the cert generated

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/CN=localhost"

OPENSSL_PID=$!
wait $OPENSSL_PID

mv  /usr/local/bin/self-signed.conf /etc/nginx/snippets/self-signed.conf

exec nginx -g 'daemon off;'