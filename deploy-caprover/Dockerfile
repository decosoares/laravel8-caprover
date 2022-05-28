FROM webdevops/php-nginx:8.0

#aplicação laravel
USER application
ENV APP_ENV laravel
ENV PHP_DATE_TIMEZONE America/Maceio
#ENV WEB_DOCUMENT_ROOT /app/public
WORKDIR /var/www		
COPY --chown=application:application ./ /var/www/
COPY deploy-caprover/nginx/default.conf /opt/docker/etc/nginx/

# Install system dependencies
USER root
# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

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
RUN chown www-data:www-data /var/www
RUN chmod 744 /var/www
RUN find /app -type f -exec chmod 644 '{}' \;
RUN find /app -type d -exec chmod 755 '{}' \;
RUN chgrp -R www-data storage bootstrap/cache && chmod -R ug+rwx storage bootstrap/cache
USER application
EXPOSE 80
