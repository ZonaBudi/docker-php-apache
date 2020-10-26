FROM php:7.4-apache

LABEL maintaner="zona.budi11@gmail.com"

ENV COMPOSER_HOME=/usr/local/composer \
    PATH=/usr/local/composer/vendor/bin:$PATH COMPOSER_ALLOW_SUPERUSER=1

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes update && \
    apt-get -y --force-yes --no-install-recommends install \
    supervisor \
    cron \
# Composer dependencies:
    openssl \
    zip \
    unzip \
    curl \
    wget \
    git \
    mercurial \
    subversion \
# Composer
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/composer \
    && chown www-data:www-data $COMPOSER_HOME \
    && chown www-data:www-data $COMPOSER_HOME -R \
    && chmod 775 $COMPOSER_HOME \
    && chmod 775 $COMPOSER_HOME -R \
# Cleanup
    && rm -rf /var/lib/apt/lists/*

RUN install-php-extensions \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    intl \
    ldap \
    memcached \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    redis \
    soap \
    xsl \
    zip \
    sockets \
    pdo_sqlsrv \
    sqlsrv \
    rdkafka \ 
    && a2enmod rewrite

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]