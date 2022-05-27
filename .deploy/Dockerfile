FROM webdevops/php-nginx:8.0-alpine

# Install Laravel framework system requirements (https://laravel.com/docs/8.x/deployment#optimizing-configuration-loading)
RUN apk add oniguruma-dev postgresql-dev libxml2-dev
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions intl bcmath gd pdo_mysql pdo_pgsql opcache redis uuid exif pcntl zip

# Copy Composer binary from the Composer official Docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

USER application
ENV WEB_DOCUMENT_ROOT /app/public
ENV APP_ENV production
WORKDIR /app
COPY --chown=application:application ./ ./

#Ajuste de permissões
USER root
RUN usermod -a -G www-data application
#RUN chown -R www-data:www-data /app
RUN find /app -type f -exec chmod 644 '{}' \;
RUN find /app -type d -exec chmod 755 '{}' \;
RUN chgrp -R www-data storage bootstrap/cache && chmod -R ug+rwx storage bootstrap/cache

USER application

EXPOSE 80

COPY ./.deploy/entrypoint.sh /

ENTRYPOINT ["sh", "/entrypoint.sh"]
