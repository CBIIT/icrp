FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf -y update \
   && dnf -y install \
   cyrus-sasl-plain \
   git \
   httpd \
   libtool-ltdl \
   libtool-ltdl-devel \
   libzip-devel \
   make \
   mod_fcgid \
   dovecot \
   dovecot-mysql \
   nodejs \
   patch \
   php8.1 \
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
   postfix \
   sendmail \
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
   msodbcsql18 \
   unixODBC-devel \
   && dnf clean all

RUN alternatives --set mta /usr/sbin/sendmail.postfix

RUN pecl channel-update pecl.php.net \
   && pecl install \
   pdo_sqlsrv \
   sqlsrv \
   zip

# RUN setsebool -P httpd_can_network_connect_db 1

ARG COMPOSER_VERSION=2.4.1

RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /bin/composer \
   && chmod +x /bin/composer

ARG UID=1000

ARG GID=1000

RUN groupadd --gid ${GID} icrp

RUN useradd --uid ${UID} --gid ${GID} -s /bin/bash icrp

RUN sed -i 's/User apache/User icrp/g' /etc/httpd/conf/httpd.conf

RUN sed -i 's/Group apache/Group icrp/g' /etc/httpd/conf/httpd.conf 

RUN sed -i 's/apache/icrp/g' /etc/php-fpm.d/www.conf

RUN mkdir -p \
   /run/httpd \
   /run/php-fpm \
   && chown -R icrp:icrp \
   /run/httpd/ \
   /run/php-fpm \
   /var/www/html \
   /var/log/httpd \
   /var/log/php-fpm

WORKDIR /var/www/html

RUN mkdir -p \
   modules/custom \
   sites/default \
   themes/boostrap_subtheme \
   utility

COPY docker/httpd-custom.conf /etc/httpd/conf.d/

COPY docker/php-custom.ini /etc/php.d/

COPY docker/postfix-main.cf /etc/postfix/main.cf

COPY composer.json composer.lock ./

RUN composer install

COPY sites/ sites/

COPY modules/custom/ modules/custom/

COPY themes/bootstrap_subtheme/ themes/bootstrap_subtheme/

COPY libraries/ libraries/

ENV PATH "$PATH:/var/www/html/vendor/bin"

EXPOSE 80
EXPOSE 443

CMD rm -rf \
   /run/httpd/* \
   /run/php-fpm/* \
   /tmp/httpd* \
   && chown -R icrp:icrp /var/www/html/ || true \
   && postfix start \
   && php-fpm -D \
   && apachectl -DFOREGROUND
