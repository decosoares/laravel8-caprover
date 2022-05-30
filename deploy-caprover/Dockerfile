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

#RUN composer install --no-interaction --optimize-autoloader --no-dev

# Set any ENVs
ARG APP_KEY=${APP_KEY}
ARG APP_NAME=${APP_NAME}
ARG APP_URL=${APP_URL}
ARG APP_ENV=${APP_ENV}
ARG APP_DEBUG=${APP_DEBUG}

ARG LOG_CHANNEL=${LOG_CHANNEL}

ARG DB_CONNECTION=${DB_CONNECTION}
ARG DB_HOST=${DB_HOST}
ARG DB_PORT=${DB_PORT}
ARG DB_DATABASE=${DB_DATABASE}
ARG DB_USERNAME=${DB_USERNAME}
ARG DB_PASSWORD=${DB_PASSWORD}

ARG BROADCAST_DRIVER=${BROADCAST_DRIVER}
ARG CACHE_DRIVER=${CACHE_DRIVER}
ARG QUEUE_CONNECTION=${QUEUE_CONNECTION}
ARG SESSION_DRIVER=${SESSION_DRIVER}
ARG SESSION_LIFETIME=${SESSION_LIFETIME}

ARG REDIS_HOST=${REDIS_HOST}
ARG REDIS_PASSWORD=${REDIS_PASSWORD}
ARG REDIS_PORT=${REDIS_PORT}

ARG MAIL_MAILER=${MAIL_MAILER}
ARG MAIL_HOST=${MAIL_HOST}
ARG MAIL_PORT=${MAIL_PORT}
ARG MAIL_USERNAME=${MAIL_USERNAME}
ARG MAIL_PASSWORD=${MAIL_PASSWORD}
ARG MAIL_ENCRYPTION=${MAIL_ENCRYPTION}
ARG MAIL_FROM_ADDRESS=${MAIL_FROM_ADDRESS}
ARG MAIL_ENCRYPTION=${MAIL_ENCRYPTION}
ARG MAIL_FROM_NAME=${APP_NAME}

ARG PUSHER_APP_ID=${PUSHER_APP_ID}
ARG PUSHER_APP_KEY=${PUSHER_APP_KEY}
ARG PUSHER_APP_SECRET=${PUSHER_APP_SECRET}
ARG PUSHER_APP_CLUSTER=${PUSHER_APP_CLUSTER}

#RUN php artisan key:generate
#RUN php artisan route:cache
#RUN php artisan view:cache
#RUN php artisan migrate --force

USER application

EXPOSE 80
COPY ./deploy-caprover/entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
