#!/bin/bash
#Ajuste de permiss�es
usermod -a -G www-data application
find /app -type f -exec chmod 644 '{}' \;
find /app -type d -exec chmod 755 '{}' \;
chgrp -R www-data storage bootstrap/cache && chmod -R ug+rwx storage bootstrap/cache

#instalar depend�ncias da aplica��o via composer
cd /app && composer install --no-interaction --optimize-autoloader --no-dev && \
#gerar vari�vel app key
php artisan key:generate && \
# Optimizing Route loading
php artisan route:cache && \
# Optimizing View loading
php artisan view:cache && \
#atualiza��o da base de dados
php artisan migrate --force && \
#inicializa��o do servi�o de fila via supervisor
#supervisorctl start queue:
