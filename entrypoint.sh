#!/bin/bash
set -e

echo "🚀 Starting Laravel on Railway..."

# Fix permission
chown -R www-data:www-data storage bootstrap/cache

# IMPORTANT: delete cached config manually
echo "🧹 Removing old cached config..."
rm -f bootstrap/cache/config.php
rm -f bootstrap/cache/routes.php
rm -f bootstrap/cache/services.php
rm -f bootstrap/cache/packages.php

# Storage link
if [ ! -L "public/storage" ]; then
    echo "🔗 Creating storage link..."
    php artisan storage:link || true
fi

# Show DB config for debug
echo "📌 Current DB_CONNECTION=$DB_CONNECTION"

# Run migrations
echo "📦 Running migrations..."
php artisan migrate --force

# Cache again after migrate
echo "⚡ Caching config..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start services
echo "🌐 Starting Nginx..."
service nginx start

echo "🐘 Starting PHP-FPM..."
php-fpm
