# Use an official PHP runtime as the base image
FROM php:7.4-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the contents of the current directory to the working directory
COPY . .

# Install required PHP extensions and other dependencies
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libpng-dev \
    libpq-dev \
    libzip-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    zip

# Enable Apache modules
RUN a2enmod rewrite

# Download and install WordPress
RUN curl -O https://wordpress.org/latest.tar.gz
RUN tar -zxvf latest.tar.gz --strip-components=1
RUN rm latest.tar.gz

# Set the appropriate file permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Expose port 80 for Apache
EXPOSE 80

# Start Apache service
CMD ["apache2-foreground"]
