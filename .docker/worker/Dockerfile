FROM php:8.2-fpm-alpine

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev \
    make

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories


# Add Build Dependencies
RUN apk add --no-cache \
    php82-pear \
    libwebp-dev \
    libzip-dev \
    libjpeg-turbo-dev \
    libjpeg-turbo \
    libpng-dev \
    libxpm-dev \
    php82-dev gcc \
    zlib-dev \
    curl-dev \
    imagemagick \
    imagemagick-dev \
    freetype-dev \
    icu-dev \
    g++ \
    npm \
    zip \
    supervisor

# Configure & Install Extension
RUN docker-php-ext-install -j "$(nproc)" \
    curl \
    pgsql \
    pdo \
    pdo_pgsql \
    bcmath \
    zip


RUN docker-php-ext-configure intl && \
    docker-php-ext-install intl &&\
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql


RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-install pcntl

#Install Redis
RUN pecl install redis && docker-php-ext-enable redis

# Setup Crontab
RUN touch /var/log/cron.log
COPY .docker/worker/cron /etc/cron.d/cron
RUN chmod 755 /etc/cron.d/cron && crontab /etc/cron.d/cron

# Setup Supervisor
COPY .docker/worker/worker.conf /etc/supervisor/conf.d/worker.conf
COPY .docker/worker/supervisord.conf /etc/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/worker.conf /etc/supervisord.conf

# Setup PHP Configuration
COPY .docker/worker/php.ini $PHP_INI_DIR/conf.d/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# Set Working Directory
WORKDIR /var/www/app

# Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]