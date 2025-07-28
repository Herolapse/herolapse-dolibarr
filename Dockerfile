FROM php:8.3-apache
WORKDIR /var/www/html/

# Enable apache mods
RUN a2enmod rewrite
RUN a2enmod headers

# Install composer
COPY --from=composer:2.8.8 /usr/bin/composer /usr/bin/composer

# Install dependencies
RUN apt-get update && apt-get install -y openssl libssl-dev libfreetype6-dev libjpeg62-turbo-dev libmagickwand-dev libpng-dev libwebp-dev libzip-dev pkg-config unzip default-mysql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN pecl install imagick
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli

RUN docker-php-ext-enable gd
RUN docker-php-ext-enable imagick
RUN docker-php-ext-enable mysqli

# Copy environmental configuration
COPY .docker/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY .docker/php.ini /usr/local/etc/php/php.ini
