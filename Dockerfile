# -------------------------------
# 1. Dùng PHP-FPM chính thức
# -------------------------------
FROM php:8.2-fpm

# -------------------------------
# 2. Cài đặt thư viện & extension cần thiết
# -------------------------------
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libonig-dev libxml2-dev zip curl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd opcache

# Bật opcache để tối ưu production
RUN docker-php-ext-enable opcache

# -------------------------------
# 3. Cài Composer (phiên bản mới nhất)
# -------------------------------
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# -------------------------------
# 4. Thiết lập thư mục làm việc
# -------------------------------
WORKDIR /var/www

# -------------------------------
# 5. Copy file dự án Laravel vào container
# -------------------------------
COPY . .

# -------------------------------
# 6. Cài đặt Laravel (chỉ production)
# -------------------------------
RUN composer install --no-dev --optimize-autoloader \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# -------------------------------
# 7. Quyền truy cập cho storage & bootstrap/cache
# -------------------------------
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# -------------------------------
# 8. Chạy PHP-FPM
# -------------------------------
CMD ["php-fpm"]
