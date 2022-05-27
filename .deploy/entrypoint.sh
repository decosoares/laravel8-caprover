#!/bin/sh

echo "🎬 entrypoint.sh: [$(whoami)] [PHP $(php -r 'echo phpversion();')]"

composer install --prefer-dist --no-scripts --no-dev --no-autoloader
composer dump-autoload --no-interaction --no-dev --optimize

echo "🎬 artisan commands"
php artisan config:cache
# 💡 Group into a custom command e.g. php artisan app:on-deploy
php artisan migrate --no-interaction --force

echo "🎬 start supervisord"

#supervisord -c $LARAVEL_PATH/.deploy/config/supervisor.conf
