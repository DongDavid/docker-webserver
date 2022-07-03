FROM php:7.3-fpm

MAINTAINER dongdavid

ADD redis-5.3.1.tgz /tmp
ADD xdebug-2.9.6.tgz /tmp
ADD imagick-3.4.4.tgz /tmp
RUN apt-get update \
    && apt install ca-certificates
RUN apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libzip-dev \
    libxml2 \
    libxml2-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libssl-dev \
    unzip \
    gnupg2 \
    nginx \
    git \
    redis-server \
    supervisor \
    && docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pcntl \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) soap \
    && mv /tmp/redis-5.3.1 /usr/src/php/ext/redis \
    && mv /tmp/xdebug-2.9.6 /usr/src/php/ext/xdebug \
    && mv /tmp/imagick-3.4.4 /usr/src/php/ext/imagick \
    && docker-php-ext-install redis \
    && docker-php-ext-install xdebug \
    && docker-php-ext-install imagick \
    && git clone https://github.com/mongodb/mongo-php-driver.git /usr/src/php/ext/mongo \
    && cd /usr/src/php/ext/mongo \
    && git submodule update --init \
    && docker-php-ext-configure mongo --with-mongodb-ssl \
    && docker-php-ext-install mongo \
    && docker-php-source delete 
RUN php -r "copy('https://install.phpcomposer.com/installer', '/tmp/composer-setup.php');" \
    && php /tmp/composer-setup.php \
    && php -r "unlink('/tmp/composer-setup.php');" \
    && mv composer.phar /usr/local/sbin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && chmod +x /usr/local/sbin/composer \
    && mkdir /data
COPY default /etc/nginx/sites-available/
COPY zz-docker.conf /usr/local/etc/php-fpm.d/
COPY docker-php-entrypoint /usr/local/bin
RUN chmod +x /usr/local/bin/docker-php-entrypoint
WORKDIR /data
EXPOSE 80



