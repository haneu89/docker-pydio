FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y wget unzip vim
# RUN wget -O- http://nginx.org/keys/nginx_signing.key | apt-key add -
# RUN wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add -
# RUN echo deb http://nginx.org/packages/debian/ jessie nginx > /etc/apt/sources.list.d/nginx.list
# RUN echo deb-src http://nginx.org/packages/debian/ jessie nginx >> /etc/apt/sources.list.d/nginx.list
# RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
RUN apt-get update

RUN apt install -y nginx

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt install -y php 
RUN apt install -y php-fpm php-mysql php-curl php-json php-gd php-intl php-mbstring php-xml php-zip php-exif php-apcu php-sqlite3
RUN chown -R www-data:www-data /var/www

RUN sed -ri -e "s/^post_max_size.*/post_max_size = 20G/" /etc/php/7.2/fpm/php.ini
RUN sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = 20G/" /etc/php/7.2/fpm/php.ini
RUN sed -ri -e "s/^max_file_uploads.*/max_file_uploads = 20000/" /etc/php/7.2/fpm/php.ini
RUN sed -ri -e "s/^memory_limit.*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini

RUN /etc/init.d/php7.2-fpm start

COPY pydio.conf /etc/nginx/sites-available/pydio.conf
RUN cd /etc/nginx/sites-enabled
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/pydio.conf /etc/nginx/sites-enabled/pydio.conf

RUN cd /var/www
COPY pydio-core-8.2.0.zip /var/www/pydio-core-8.2.0.zip

RUN unzip /var/www/pydio-core-8.2.0.zip -d /var/www
RUN ls -la /var/www
RUN mv /var/www/pydio-core-8.2.0 /var/www/pydio
RUN chown -R www-data:www-data /var/www/pydio

RUN /etc/init.d/php7.2-fpm start

EXPOSE 80 443

CMD /etc/init.d/php7.2-fpm restart && nginx -g "daemon off;"