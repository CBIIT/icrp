# ICRP

This repository contains the source code for the International Cancer Research Partnership website. 

## JavaScript DOM regression tests

From the repository root, run `python3 -m http.server 8000 --bind 127.0.0.1`
and open <http://127.0.0.1:8000/test/unit/js/dom-rendering.html> in a browser.
The page loads the actual map and theme scripts with the repository's bundled
jQuery; no npm dependencies or Drupal database are required. All 24 tests should
pass, covering literal map/calendar titles (including markup and entities),
legend interactions, repeated calendar initialization, and query parsing.

After deploying changes to Drupal libraries or their JavaScript, rebuild the
Drupal cache (`drush cr`) so updated library definitions and asset versions take
effect, and verify the JavaScript served by the affected pages.

## Getting Started with Docker Compose

In the current directory, run:

```bash
docker-compose build
docker-compose up -d
```

To use the alternative docker-compose-dev.yml for local development, run:
```bash
docker-compose -f docker-compose-dev.yml build
docker-compose -f docker-compose-dev.yml up -d
```

If you have any services running on the host (eg: mysql), ensure that your settings.php database entries use `host.docker.internal` as the host.

If database services are running behind a bastion host, use the following command to use ssh as a proxy:

```bash
ssh -i $PRIVATE_KEY -N -L $LOCAL_SERVICE_PORT:$REMOTE_SERVICE_HOST:$REMOTE_SERVICE_PORT $BASTION_USER@$BASTION_HOST
```

## Prerequisites

#### Required system packages (CentOS 6/7)
- httpd_2.4
- php_7.x

#### Required php modules
- gd
- json
- mbstring
- mysqlnd
- pdo
- pdo_mysql
- [pdo_sqlsrv](https://github.com/Microsoft/msphpsql)
- xml

#### Recommended php modules
- opcache
- pecl-apcu
- php-fpm

#### Required tools
- composer
- drush

## Getting Started

```bash
## Assuming the document root is under the "web" directory:
git clone https://github.com/CBIIT/icrp web

## Set up site dependencies
cd web
composer install

## Make sure a settings.php file exists (copy default settings)
cp -f ./sites/default/default.settings.php ./sites/default/default.php

## Copy your settings.local.php file to /sites/default/settings.local.php
cp ~/settings.local.php ./sites/default/settings.local.php

## Restore the MySQL database from the icrp-2.0.sql file. 
## For example, assuming we have defined a "drupal" database:
mysql drupal < ./database/MYSQL/SQL_dump/icrp-2.0.sql

## Update drupal database (if needed)
drush updatedb

## Update entities (optional)
drush entity-updates

## Rebuild drupal cache
drush cr
```
