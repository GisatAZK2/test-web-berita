# ============================
# Stage 1: Build Dependencies
# ============================
FROM php:8.3-fpm AS build

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        intl \
        gd \
        zip \
        pdo_mysql \
        fileinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy Laravel files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Optimize Laravel caches
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# ============================
# Stage 2: Runtime Image
# ============================
FROM php:8.3-fpm

# Install runtime extensions again
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        intl \
        gd \
        zip \
        pdo_mysql \
        fileinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www

# Copy app from build stage
COPY --from=build /var/www /var/www

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Permission fix
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port
EXPOSE 8080

# Start Nginx + PHP-FPM
CMD service nginx start && php-fpm
