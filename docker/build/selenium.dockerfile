FROM centos:latest

LABEL \
    BASE_OS="CentOS 7" \
    DEFAULT_TAG="8" \
    DESCRIPTION="Selenium" \
    VERSION="1.0" \
    UID="SELENIUM"


RUN { \
    echo "[google-chrome]" ; \
    echo "name=google-chrome" ; \
    echo "baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64" ; \
    echo "enabled=1" ; \
    echo "gpgcheck=1" ; \
    echo "gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" ; \
} | tee "/etc/yum.repos.d/google-chrome.repo"

RUN yum makecache fast \
 && yum -y update \
 && yum -y install \
    bzip2 \
    firefox \
    fontconfig \
    gnu-free-sans-fonts \
    google-chrome-stable \
    maven \
    mesa-libOSMesa \
    unzip \
    xorg-x11-server-Xvfb \
 && yum -y clean all

RUN ln -s /usr/lib64/libOSMesa.so.8 /opt/google/chrome/libosmesa.so

RUN dbus-uuidgen > /var/lib/dbus/machine-id

RUN curl -L https://chromedriver.storage.googleapis.com/2.30/chromedriver_linux64.zip -o /tmp/chromedriver.zip \
 && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 -o /tmp/phantomjs.tar.bz2 \
 && curl -L https://github.com/mozilla/geckodriver/releases/download/v0.17.0/geckodriver-v0.17.0-linux64.tar.gz -o /tmp/geckodriver.tar.gz \
 && tar xf /tmp/geckodriver.tar.gz -C /usr/local/bin geckodriver \
 && tar xjf /tmp/phantomjs.tar.bz2 -C /usr/local/bin phantomjs-2.1.1-linux-x86_64/bin/phantomjs --strip-components=2 \
 && unzip /tmp/chromedriver.zip -d /usr/local/bin \
 && chmod 755 /usr/local/bin/chromedriver /usr/local/bin/phantomjs /usr/local/bin/geckodriver

COPY "./selenium.entrypoint.sh" "/usr/bin/entrypoint.sh"

RUN chmod 755 /usr/bin/entrypoint.sh \
 && ln -s /usr/bin/entrypoint.sh /entrypoint.sh

CMD ["entrypoint.sh"]
