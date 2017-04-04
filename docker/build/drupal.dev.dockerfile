FROM centos:latest

LABEL \
    BASE_OS="CentOS 7" \
    DEFAULT_TAG="8" \
    DESCRIPTION="CentOS 7 / httpd / php " \
    VERSION="1.0" \
    UID="DRUPAL_8"

RUN curl --silent --location https://rpm.nodesource.com/setup_7.x | bash - \ 
 && curl https://packages.microsoft.com/config/rhel/7/prod.repo -o /etc/yum.repos.d/mssql-release.repo \
 && yum makecache fast \ 
 && yum -y update \
 && yum -y install epel-release \
 && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
 && yum -y install \
    gcc \
    gcc-c++ \
    httpd24u \
    httpd24u-mod_ssl \
    make \
    mariadb101u \
    mod_php71u \
    nodejs \
    pear1u \
    php71u-cli \
    php71u-common \
    php71u-devel \
    php71u-fpm \
    php71u-fpm-httpd \
    php71u-gd \
    php71u-json \
    php71u-mbstring \
    php71u-mysqlnd \
    php71u-opcache \
    php71u-pdo \
#   php71u-pdo-dblib \
    php71u-pecl-apcu \
    php71u-pecl-xdebug \
    php71u-pgsql \
    php71u-xml \
 && ACCEPT_EULA=Y yum -y install msodbcsql mssql-tools \
 && yum -y remove unixODBC \
 && yum -y install unixODBC-utf16-devel \
 && yum -y clean all \
 && pecl install sqlsrv \
 && pecl install pdo_sqlsrv

RUN { \
    echo "#RewriteEngine On"                                   ; \
    echo "#RewriteCond %{HTTPS} off"                           ; \
    echo "#RewriteRule (.*) https://%{SERVER_NAME}/$1 [R,L]"   ; \
} | tee "/etc/httpd/conf.d/rewrite-https.conf"

RUN { \
    echo "ServerName localhost"                                ; \
    echo "ServerSignature Off"                                 ; \
    echo "ServerTokens Prod"                                   ; \
    echo "TraceEnable Off"                                     ; \
    echo "Header always append X-Frame-Options SAMEORIGIN"     ; \
    echo "Header set X-XSS-Protection \"1; mode=block\""       ; \
} | tee "/etc/httpd/conf.d/docker-htttpd.conf"

RUN { \
    echo "AccessFileName .htaccess"                            ; \
    echo "DirectoryIndex disabled"                             ; \
    echo "DirectoryIndex index.php index.html"                 ; \
    echo                                                       ; \
    echo "<FilesMatch \.php$>"                                 ; \
    echo "    SetHandler application/x-httpd-php"              ; \
    echo "</FilesMatch>"                                       ; \
    echo                                                       ; \
    echo "<Directory /var/www/html/>"                          ; \
    echo "    Options -Indexes"                                ; \
    echo "    AllowOverride All"                               ; \
    echo "</Directory>"                                        ; \
} | tee "/etc/httpd/conf.d/docker-php.conf"

RUN { \
    echo "<filesMatch \"\.(js|html|css)$\""                    ; \
    echo "    SetOutputFilter DEFLATE"                         ; \
    echo "</filesMatch>"                                       ; \
} | tee "/etc/httpd/conf.d/deflate.conf"

RUN { \
    echo "[opcache]"                          ; \
    echo "opcache.memory_consumption=128"     ; \
    echo "opcache.interned_strings_buffer=8"  ; \
    echo "opcache.max_accelerated_files=4000" ; \
    echo "opcache.revalidate_freq=60"         ; \
    echo "opcache.fast_shutdown=1"            ; \
    echo "opcache.enable_cli=1"               ; \
} | tee "/etc/php.d/opcache.ini"

RUN { \
    echo "[xdebug]"                           ; \
    echo "xdebug.remote_enable = 1"           ; \
    echo "xdebug.remote_autostart = 1"        ; \
} | tee "/etc/php.d/xdebug.ini"

RUN { \
    echo "[sqlsrv]"                           ; \
    echo "extension = sqlsrv.so"              ; \
} | tee "/etc/php.d/sqlsrv.ini"

RUN { \
    echo "[pdo_sqlsrv]"                       ; \
    echo "extension = pdo_sqlsrv.so"          ; \
} | tee "/etc/php.d/pdo_sqlsrv.ini"

RUN curl https://getcomposer.org/composer.phar -o /usr/local/bin/composer \
 && curl https://s3.amazonaws.com/files.drush.org/drush.phar -o /usr/local/bin/drush \
 && chmod 755 /usr/local/bin/composer /usr/local/bin/drush \
 && chown -R apache:apache /var/www/html \
 && chmod 775 /var/www/html

EXPOSE 80
EXPOSE 443

COPY "./drupal.entrypoint.sh" "/usr/bin/entrypoint.sh"

RUN chmod 755 /usr/bin/entrypoint.sh \
 && ln -s /usr/bin/entrypoint.sh /entrypoint.sh

CMD ["entrypoint.sh"]
