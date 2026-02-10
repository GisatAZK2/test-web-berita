#!/bin/bash

echo "🚀 Starting Laravel Container..."

# Ensure correct permission
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Storage link (for public image access)
if [ ! -L "/var/www/public/storage" ]; then
    echo "🔗 Creating storage link..."
    php artisan storage:link || true
fi

# Generate APP_KEY if missing
if [ -z "$APP_KEY" ]; then
    echo "🔑 APP_KEY missing, generating..."
    php artisan key:generate --force
else
    echo "✅ APP_KEY already set"
fi

# Clear and cache config
echo "⚡ Optimizing config cache..."
php artisan config:clear
php artisan config:cache

# Optional: migrate database automatically (enable if needed)
# php artisan migrate --force

# Start services
echo "🌐 Starting Nginx..."
service nginx start

echo "🐘 Starting PHP-FPM..."
php-fpm
