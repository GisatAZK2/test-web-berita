# ============================
# Stage 1: Build Laravel
# ============================
FROM php:8.3-fpm AS build

# Install system dependencies + PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip zip \
    libzip-dev libicu-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        intl \
        gd \
        zip \
        pdo_mysql \
        fileinfo \
        exif \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy Laravel source code
COPY . .

# Install dependencies without dev
RUN composer install --no-dev --optimize-autoloader

# Cache Laravel config/routes/views
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache


# ============================
# Stage 2: Runtime Image
# ============================
FROM php:8.3-fpm

# Install runtime dependencies + extensions again
RUN apt-get update && apt-get install -y \
    nginx \
    libzip-dev libicu-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        intl \
        gd \
        zip \
        pdo_mysql \
        fileinfo \
        exif \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

# Copy Laravel app from build stage
COPY --from=build /var/www /var/www

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Fix Laravel permission
RUN chown -R www-data:www-data \
    /var/www/storage \
    /var/www/bootstrap/cache

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Railway uses PORT env variable
EXPOSE 8080

CMD ["/entrypoint.sh"]
