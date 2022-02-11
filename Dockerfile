#FROM dockerhub/iiiorg/laravel8-php7.4:1.0
FROM dockerhub/bitnami/laravel:8-debian-10


# 將使用者需要安裝的清單放到opt資料夾內
COPY ./apt-package.txt /opt/
# 為了避免發生測試時的下載封鎖 因此先禁用
#RUN cd /opt/ && apt-get update && \
#    cat apt-package.txt | xargs apt-get install -y
#RUN cd /opt/ && \
#    cat apt-package.txt | xargs apk add
RUN cd /opt/ && \
    cat apt-package.txt | xargs apt install -y

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
