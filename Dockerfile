FROM php:7.4-fpm-alpine

RUN apk add --no-cache --virtual .deps \
    git \
    icu-libs \
    zlib \
    openssh \
    imagemagick \
    imagemagick-libs \
    imagemagick-dev \
    freetype \
    libpng \
    libjpeg-turbo \
    libxslt

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    libxslt-dev \
    icu-dev \
    zlib-dev \
    libzip-dev \
    gmp-dev \
    && docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    intl \
    pdo \
    soap \
    pcntl \
    exif \
    gd \
    gmp \
    pdo_mysql \
    zip \
    && pecl install \
    imagick \
    redis \
    && docker-php-ext-enable --ini-name 20-imagick.ini imagick \
    && docker-php-ext-enable --ini-name 20-redis.ini redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
