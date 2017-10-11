# ICRP

This repository contains the source code for the International Cancer Research Partnership website. 

## Prerequisites

#### Required system packages (CentOS 6/7)
- httpd_2.4
- php_7.x

#### Required php modules
Required php modules:
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

## Copy your settings.local.php file to /sites/default/settings.local.php
cp ~/settings.local.php ./sites/default/settings.local.php

## Restore the MySQL database from the obsolete.icrp.sql file. For example,
## assuming we have defined a "drupal" database
mysql drupal < obsolete.icrp.sql

## Rebuild drush cache
drush cr
```
