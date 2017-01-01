#!/bin/bash
chown -R apache:apache /var/www/html

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND