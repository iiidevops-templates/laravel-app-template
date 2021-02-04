FROM iiiorg/php7.3-apache:latest

# 將使用者需要安裝的清單放到opt資料夾內
COPY ./app/apt-package.txt /opt/
# 為了避免發生測試時的下載封鎖 因此先禁用
RUN cd /opt/ && apt-get update && \
    cat apt-package.txt | xargs apt-get install -y

#------ 預計之後拿掉
# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Install PHP_CodeSniffer
RUN composer global require "squizlabs/php_codesniffer=*"

# Cleanup dev dependencies
RUN apk del -f .build-deps
#------

# Setup working directory
WORKDIR /var/www

# create laravel latest version project
COPY app /var/www
RUN composer install
RUN cp .env.example .env
RUN php artisan key:generate

# Run service
EXPOSE 80
CMD php artisan serve --port=80 --host=0.0.0.0 
