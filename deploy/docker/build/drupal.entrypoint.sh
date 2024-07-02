#!/bin/bash

WEBROOT=/var/www/html 

if [ -f $WEBROOT/composer.json ]; then
  pushd $WEBROOT
  composer install
  popd
fi

chown -R apache:apache $WEBROOT

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -D FOREGROUND
