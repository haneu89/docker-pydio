FROM ubuntu:18.04

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y wget unzip vim nginx php php-fpm php-mysql php-curl php-json php-gd php-intl php-mbstring php-xml php-zip php-exif php-apcu php-sqlite3
<<<<<<< HEAD
=======
RUN chown -R www-data:www-data /var/www
>>>>>>> 595eefe461170ab1a21e726a60a6827e4b79d7e6

COPY pydio-core-8.2.0.zip /var/www/pydio-core-8.2.0.zip

RUN unzip -jo /var/www/pydio-core-8.2.0.zip 'pydio-core-8.2.0/*' -d /var/www/pydio
RUN chown -R www-data:www-data /var/www

RUN rm /etc/nginx/sites-enabled/default
COPY pydio.conf /etc/nginx/sites-available/pydio.conf
RUN ln -s /etc/nginx/sites-available/pydio.conf /etc/nginx/sites-enabled/pydio.conf

<<<<<<< HEAD
RUN /etc/init.d/php7.2-fpm start

RUN sed -i -e "s/^post_max_size.*/post_max_size = 20G/" /etc/php/7.2/fpm/php.ini \
  -e "s/^upload_max_filesize.*/upload_max_filesize = 20G/" /etc/php/7.2/fpm/php.ini \
  -e "s/^max_file_uploads.*/max_file_uploads = 20000/" /etc/php/7.2/fpm/php.ini \
  -e "s/^memory_limit.*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini \
  -e '/sendfile/i\\tclient_max_body_size 20G;' /etc/nginx/nginx.conf
=======
RUN cd /var/www
COPY pydio-core-8.2.0.zip /var/www/pydio-core-8.2.0.zip

RUN unzip /var/www/pydio-core-8.2.0.zip -d /var/www
RUN mv /var/www/pydio-core-8.2.0 /var/www/pydio
RUN chown -R www-data:www-data /var/www/pydio
>>>>>>> 595eefe461170ab1a21e726a60a6827e4b79d7e6

EXPOSE 80 443

CMD /etc/init.d/php7.2-fpm restart && nginx -g "daemon off;"