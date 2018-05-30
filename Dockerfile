FROM php:5.6-fpm-jessie

# From https://github.com/torchbox/docker-php/blob/master/Dockerfile.5.5-fpm
RUN apt-get update && apt-get install -y \
        git \
        zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libssl-dev \
        libmemcached-dev \
        libz-dev \
        libmysqlclient18 \
        zlib1g-dev \
        libsqlite3-dev \
        libxml2-dev \
        libcurl3-dev \
        libedit-dev \
        libpspell-dev \
        libldap2-dev \
        unixodbc-dev \
        libpq-dev

# https://bugs.php.net/bug.php?id=49876
RUN ln -fs /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/

RUN echo "Installing PHP extensions" \
    && docker-php-ext-install iconv mcrypt gd pdo_mysql pcntl zip bcmath simplexml xmlrpc soap pspell ldap mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install Postgre PDO
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/bin
ENV PATH /root/.composer/vendor/bin:$PATH

# get redis ext
RUN apt-get install -y gcc make autoconf libc-dev pkg-config
RUN pecl install redis-2.2.8
# Enable ext
RUN docker-php-ext-enable redis.so

# for instal new ext use
# RUN docker-php-ext-install <ext-name> && docker-php-ext-configure <ext-name>

EXPOSE 9000
CMD ["php-fpm"]
