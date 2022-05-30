#!/bin/sh

echo "🎬 entrypoint.sh: [$(whoami)] [PHP $(php -r 'echo phpversion();')]"

#composer dump-autoload --no-interaction --no-dev --optimize
composer install --no-interaction --optimize-autoloader --no-dev

echo "🎬 artisan commands"

# 💡 Group into a custom command e.g. php artisan app:on-deploy
cp .env.example .env
#php artisan migrate --no-interaction --force
php artisan key:generate

echo "🎬 start supervisord"

#supervisord -c $LARAVEL_PATH/.deploy/config/supervisor.conf
