FROM iiiorg/laravel8-php7.4:1.0

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
