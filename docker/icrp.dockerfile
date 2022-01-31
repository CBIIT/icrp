FROM ${BASE_IMAGE:-quay.io/centos/centos:stream8}

RUN dnf -y update \
 && dnf -y module enable nodejs:16 \
 && dnf -y module enable php:7.4 \
 && dnf -y install \
    curl \
    git \
    httpd \
    libzip-devel \
    make \
    mod_fcgid \
    nodejs \
    php \
    php-devel \
    php-fpm \
    php-gd \
    php-intl \
    php-json \
    php-mbstring \
    php-mysqlnd \
    php-opcache \
    php-pdo \
    php-pear \
    php-xml \
    unzip \
    wget \
    which \
 && touch /etc/php.d/90-pecl-modules.ini \
 && pear config-set php_ini /etc/php.d/90-pecl-modules.ini \
 && curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo \
 && dnf -y remove \
    unixODBC-utf16 \
    unixODBC-utf16-devel \
 && ACCEPT_EULA=Y dnf -y install \
    msodbcsql17 \
    unixODBC-devel \
 && dnf clean all

RUN pecl install \
    pdo_sqlsrv \
    sqlsrv \
    zip

# RUN setsebool -P httpd_can_network_connect_db 1

ARG COMPOSER_VERSION=1.10.25

RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /bin/composer \
 && chmod +x /bin/composer

WORKDIR /var/www/html

RUN mkdir -p \
    /run/php-fpm \
    modules/custom \
    sites/default \
    themes/boostrap_subtheme \
    utility

COPY docker/httpd-custom.conf /etc/httpd/conf.d/

COPY docker/php-custom.ini /etc/php.d/

COPY utility/ utility/

COPY composer.json composer.lock ./

RUN composer install

COPY modules/custom/ modules/custom/

COPY themes/bootstrap_subtheme/ themes/bootstrap_subtheme/

COPY libraries/ libraries/

ENV PATH "$PATH:/var/www/html/vendor/bin"

EXPOSE 80
EXPOSE 443

CMD rm -rf /run/httpd/* /tmp/httpd* \
 && php-fpm -D \
 && exec /usr/sbin/apachectl -DFOREGROUND