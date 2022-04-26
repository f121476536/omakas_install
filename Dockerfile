FROM php:7.4-apache-buster

WORKDIR /var/www/html/
ADD . /var/www/html/

RUN apt-get update && apt-get install -y vim libxml2-dev inetutils-ping unzip && \
    unzip omeka-s-3.2.0.zip && \
    rm omeka-s-3.2.0.zip 

#installing php extension
RUN docker-php-ext-install pdo pdo_mysql xml && \
    apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/* && \
    printf "\n" | pecl install imagick && \
    docker-php-ext-enable imagick

#changing apache2 AllowOverride from "None" to "All" and enable mod_rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf && \
    a2enmod rewrite

#changing omakes db settings
RUN sed -i 's#user     = ""#user     = "omeka-user"#g' /var/www/html/omeka-s/config/database.ini && \
    sed -i 's#password = ""#password = "omeka-pw"#g' /var/www/html/omeka-s/config/database.ini && \
    sed -i 's#dbname   = ""#dbname   = "omeka_db"#g' /var/www/html/omeka-s/config/database.ini && \
    sed -i 's#host     = ""#host     = "omeka-mysql"#g' /var/www/html/omeka-s/config/database.ini

#just for testing
RUN chmod -R 777 /var/www/html/omeka-s

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]