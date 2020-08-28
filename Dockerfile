FROM php:7.4-fpm

MAINTAINER dongdavid

ADD redis-5.3.1.tgz /tmp
ADD xdebug-2.9.6.tgz /tmp
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
    && echo 'deb http://mirrors.aliyun.com/debian/ buster main non-free contrib' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.aliyun.com/debian-security buster/updates main' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.aliyun.com/debian/ buster-updates main non-free' contrib >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.aliyun.com/debian/ buster-backports main non-free' contrib >> /etc/apt/sources.list \
    && echo 'deb-src http://mirrors.aliyun.com/debian-security buster/updates main' >> /etc/apt/sources.list \
    && echo 'deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib' >> /etc/apt/sources.list \
    && echo 'deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib' >> /etc/apt/sources.list \
    && echo 'deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib' >> /etc/apt/sources.list \
    && apt-get update \
    && apt install ca-certificates \
    && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libzip-dev \
    gnupg2 \
    nginx \
    redis-server \
    && docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pcntl \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) zip \
    && mv /tmp/redis-5.3.1 /usr/src/php/ext/redis \
    && mv /tmp/xdebug-2.9.6 /usr/src/php/ext/xdebug \
    && docker-php-ext-install redis \
    && docker-php-ext-install xdebug \
    && docker-php-source delete \
    && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/sbin/composer \
    && chmod +x /usr/local/sbin/composer
COPY default /etc/nginx/sites-available/
COPY docker-php-entrypoint /usr/local/bin
RUN chmod +x /usr/local/bin/docker-php-entrypoint
VOLUME ["/data"]
EXPOSE 80



