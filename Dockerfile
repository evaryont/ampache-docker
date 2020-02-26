FROM php:7.4-apache

ARG AMPACHE_VERSION="4.1.0"

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	libzip-dev \
        libldap2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"\
    && docker-php-ext-install -j$(nproc) gd ldap mysqli pdo_mysql opcache \
    && pecl install APCu-5.1.18 \
    && docker-php-ext-enable apcu


ENV APACHE_PORT 8080
RUN sed -ri -e 's!80!${APACHE_PORT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri -e 's!80!${APACHE_PORT}!g' /etc/apache2/apache2.conf /etc/apache2/ports.conf /etc/apache2/conf-available/*.conf


RUN apt-get install -qq --no-install-recommends wget less unzip ffmpeg

ADD php-max-upload.ini $PHP_INI_DIR/conf.d/
ADD run.sh /usr/local/bin/ampache-run.sh

RUN chmod a+x /usr/local/bin/ampache-run.sh

USER www-data
RUN wget -qO /tmp/ampache.zip https://github.com/ampache/ampache/releases/download/${AMPACHE_VERSION}/ampache-${AMPACHE_VERSION}_all.zip \
 && unzip -q /tmp/ampache.zip -d /var/www/html \
 && cp /var/www/html/config/ampache.cfg.php.dist /tmp \
 && cp /var/www/html/config/registration_agreement.php.dist /tmp \
 && mv /var/www/html/rest/.htaccess.dist /var/www/html/rest/.htaccess \
 && mv /var/www/html/play/.htaccess.dist /var/www/html/play/.htaccess \
 && mv /var/www/html/channel/.htaccess.dist /var/www/html/channel/.htaccess \
 && sed -ri -e 's/woff/woff2?/g' /var/www/html/lib/.htaccess /var/www/html/modules/.htaccess

EXPOSE 8080
VOLUME ["/media"]
CMD ["/usr/local/bin/ampache-run.sh"]
