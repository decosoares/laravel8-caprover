FROM webdevops/php-nginx:8.0-alpine

#aplicação laravel
USER application
ENV APP_ENV laravel
ENV PHP_DATE_TIMEZONE America/Maceio
#ENV WEB_DOCUMENT_ROOT /app/public
WORKDIR /var/www		
COPY --chown=application:application ./ /var/www/
COPY deploy-caprover/nginx/default.conf /etc/nginx/conf.d/

# Install system dependencies
USER root
# Add Build Dependencies
RUN apk update && apk add --no-cache --virtual .build-deps  \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    bzip2-dev \
    postgresql-dev \ 
    zip 


# Add Production Dependencies
RUN apk add --update --no-cache \
    jpegoptim \
    pngquant \
    optipng \
    supervisor \
    nano \
    icu-dev \
    freetype-dev \
    mysql-client \ 
    libzip-dev

# Configure & Install Extension
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# comandos composer, php artisan e iniciar serviço de fila com script start.sh via supervisord
COPY deploy-caprover/supervisor/start.sh /start.sh

RUN chmod +x /start.sh
COPY deploy-caprover/supervisor/start.conf /opt/docker/etc/supervisor.d/start.conf
COPY deploy-caprover/supervisor/queue.conf /opt/docker/etc/supervisor.d/queue.conf
#Ajuste de permissões
RUN usermod -a -G www-data application
#RUN chown -R www-data:www-data /app
RUN find /app -type f -exec chmod 644 '{}' \;
RUN find /app -type d -exec chmod 755 '{}' \;
RUN chgrp -R www-data storage bootstrap/cache && chmod -R ug+rwx storage bootstrap/cache
USER application
EXPOSE 80
