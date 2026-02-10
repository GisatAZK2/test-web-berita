#!/bin/bash
set -e

echo "🚀 Starting Laravel on Railway..."

# Railway does NOT use .env file
echo "✅ Using Railway Environment Variables"

# Fix permissions
chown -R www-data:www-data storage bootstrap/cache

# Storage link
if [ ! -L "public/storage" ]; then
    echo "🔗 Creating storage link..."
    php artisan storage:link || true
fi

# Clear cache (important in Railway)
echo "⚡ Clearing caches..."
php artisan optimize:clear

# Run migrations automatically
echo "📦 Running migrations..."
php artisan migrate --force

# Cache config for performance
echo "⚡ Caching config..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start nginx + php-fpm
echo "🌐 Starting Nginx..."
service nginx start

echo "🐘 Starting PHP-FPM..."
php-fpm
