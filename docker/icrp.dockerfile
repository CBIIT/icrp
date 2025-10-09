ettROM public.ecr.aws/amazonlinux/amazonlinux:2023

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
   php8.3 \
   php8.3-devel \
   php8.3-fpm \
   php8.3-gd \
   php8.3-intl \
   php8.3-mbstring \
   php8.3-mysqlnd \
   php8.3-opcache \
   php-pear \
   php8.3-pdo \
   php8.3-xml \
   php8.3-zip \
   postfix \
   sendmail \
   unzip \
   wget \
   which \
   vim \
   ca-certificates \
   gcc \
   gcc-c++ \
   autoconf \
   automake \
   libtool \
   make \
   unixODBC-devel \
   && touch /etc/php.d/90-pecl-modules.ini \
   && curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo \
   && dnf -y remove \
   unixODBC-utf16 \
   unixODBC-utf16-devel \
   && ACCEPT_EULA=Y dnf -y install \
   msodbcsql18 \
   unixODBC-devel \
   && dnf clean all

# Download the latest CA certificates
RUN wget https://curl.haxx.se/ca/cacert.pem -O /etc/ssl/certs/cacert.pem

RUN alternatives --set mta /usr/sbin/sendmail.postfix

RUN pecl channel-update pecl.php.net \
   && pecl install \
   pdo_sqlsrv \
   sqlsrv \
   zip

# FIX: Explicitly ensure the SQL Server drivers are loaded for PHP 8.3 CLI (Drush)
RUN echo "extension=sqlsrv.so" >> /etc/php.d/90-pecl-modules.ini \
   && echo "extension=pdo_sqlsrv.so" >> /etc/php.d/90-pecl-modules.ini

# Download ddog and install
RUN wget https://github.com/DataDog/dd-trace-php/releases/latest/download/datadog-setup.php -O /tmp/datadog-setup.php
RUN php /tmp/datadog-setup.php --php-bin=all --enable-appsec --enable-profiling

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

RUN sed -i 's/apache/icrp/g' /etc/php-fpm.d/www.conf \
   && echo "env[DD_SERVICE]=\$DD_SERVICE" >> /etc/php-fpm.d/www.conf \
   && echo "env[DD_ENV]=\$DD_ENV" >> /etc/php-fpm.d/www.conf \
   && echo "env[DD_VERSION]=\$DD_VERSION" >> /etc/php-fpm.d/www.conf

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
   themes/bootstrap_subtheme \
   utility

COPY docker/httpd-custom.conf /etc/httpd/conf.d/
COPY docker/disable-compression.conf /etc/httpd/conf.d/

COPY docker/php-custom.ini /etc/php.d/

COPY docker/postfix-main.cf /etc/postfix/main.cf
COPY sites/ sites/

COPY composer.json ./
RUN rm -rf vendor/
RUN composer update --no-ansi --no-dev --no-scripts 

# Overlay patched redirect_after_login.module (null guard fix)
COPY deploy/overrides/modules/redirect_after_login/redirect_after_login.module modules/redirect_after_login/redirect_after_login.module


COPY modules/custom/ modules/custom/

COPY themes/bootstrap_subtheme/ themes/bootstrap_subtheme/

COPY libraries/ libraries/

ENV PATH="$PATH:/var/www/html/vendor/bin"


EXPOSE 80
EXPOSE 443
CMD ["/bin/bash", "-c", "rm -rf /run/httpd/* /run/php-fpm/* /tmp/httpd* && chown -R icrp:icrp /var/www/html/ || true && postfix start && php-fpm -D && httpd -D FOREGROUND"]
