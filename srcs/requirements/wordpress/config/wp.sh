#!/bin/bash

sudo systemctl enable nginx && sudo systemctl start nginx

# <<< extension >>>

# php-curl
#   curl http request, fetch something over HTTP or HTTPS.
#   for example install a plugin 
#   wordpress fetch that plogin using HTTP request

# php-gd
#   is a graphical library
#   that allow wordpress to create, manipulate, and resize images

# php-mbstring
#   mbstring stands for “multibyte string”.
#   allows WordPress to correctly handle Unicode and multibyte character encodings 
#   (like UTF-8, Japanese, Arabic, emojis, etc.).

# php-xml -> allows WordPress to parse and handle XML documents.

# php-xmlrpc -> not use it 

# php-soap -> not use it

# php-intl -> not use it 

# php-zip 
# example installing plugins using "php-curl"
# the plugin it comes ziped we need php-zip to install it

apt install -y php php-curl php-gd php-mbstring php-xml php-zip


