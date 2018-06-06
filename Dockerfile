FROM debian:stretch-slim

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
  && apt-get install -y wget unzip vim nginx php php-fpm php-mysql php-curl php-json php-gd php-intl php-mbstring php-xml php-zip php-exif php-apcu php-sqlite3

COPY pydio-core-8.2.0.zip /var/www/pydio.zip

RUN unzip -q /var/www/pydio.zip -d /var/www \
  && mv /var/www/pydio-core-8.2.0 /var/www/pydio \
  && chown -R www-data:www-data /var/www

COPY pydio.conf /etc/nginx/sites-available/pydio.conf

RUN sed -i -e "s/^post_max_size.*/post_max_size = 20G/" /etc/php/7.0/fpm/php.ini \
  -e "s/^upload_max_filesize.*/upload_max_filesize = 20G/" /etc/php/7.0/fpm/php.ini \
  -e "s/^max_file_uploads.*/max_file_uploads = 20000/" /etc/php/7.0/fpm/php.ini \
  -e "s/^memory_limit.*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini \
  -e '/sendfile/i\\tclient_max_body_size 20G;' /etc/nginx/nginx.conf

RUN rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default \
  && ln -s /etc/nginx/sites-available/pydio.conf /etc/nginx/sites-enabled/pydio.conf \
  && /etc/init.d/nginx restart

EXPOSE 80 443

CMD /etc/init.d/php7.0-fpm start && nginx -g "daemon off;"