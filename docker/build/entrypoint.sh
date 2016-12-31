#!/bin/bash

# create directory for Let's Encrypt
mkdir /var/www/html/.well_known
chmod 777 /var/www/html/.well_known

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND