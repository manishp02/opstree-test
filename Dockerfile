FROM php:7.1.3-fpm

WORKDIR /var/www/html/
RUN apt-get update && apt-get install -y \
    && apt-get install -y nginx \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer	
COPY php.conf /etc/nginx/sites-enabled/default
COPY entrypoint.sh /etc/entrypoint.sh
COPY . .

RUN chmod -R 777 storage

RUN composer install

EXPOSE 8080
ENTRYPOINT ["sh", "/etc/entrypoint.sh"]