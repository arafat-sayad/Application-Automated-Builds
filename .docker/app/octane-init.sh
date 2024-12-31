#!/bin/sh
set -e

#chown -R www-data:www-data /var/www/api/storage/

php /var/www/app/artisan octane:start