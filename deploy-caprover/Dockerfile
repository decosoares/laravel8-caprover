FROM webdevops/php-nginx:8.0

#aplicação laravel
USER application
ENV APP_ENV laravel
ENV PHP_DATE_TIMEZONE America/Maceio
ENV WEB_DOCUMENT_ROOT /app/public
WORKDIR /app		
# comandos composer, php artisan e iniciar serviço de fila com script start.sh via supervisord
COPY --chown=application:application ./deploy-caprover/supervisor/start.sh ./
COPY --chown=application:application ./ ./
USER root
RUN ls -la
RUN chmod 777 start.sh && chmod +x start.sh

#COPY deploy-caprover/nginx/default.conf /opt/docker/etc/nginx/conf.d/

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

COPY deploy-caprover/supervisor/start.conf /opt/docker/etc/supervisor.d/start.conf
COPY deploy-caprover/supervisor/queue.conf /opt/docker/etc/supervisor.d/queue.conf

#Ajuste de permissões
RUN usermod -aG www-data application
RUN chown -R application:www-data /app
RUN find /app -type f -exec chmod 644 '{}' \;
RUN find /app -type d -exec chmod 755 '{}' \;
RUN chgrp -R www-data storage bootstrap/cache && chmod -R ug+rwx storage bootstrap/cache

RUN composer install --no-interaction --optimize-autoloader --no-dev

RUN cp .env.example .env
RUN php artisan key:generate
#RUN php artisan route:cache
#RUN php artisan view:cache
#RUN php artisan migrate --force

USER application

EXPOSE 80
