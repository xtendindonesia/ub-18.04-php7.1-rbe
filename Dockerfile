#
# Use this dockerfile to build project
#
# docker build -t ub-18.04-php7.1-rbe
# 
# docker run -tid --name rbe-php --link mysql:mysql -v $(pwd):/var/www -p 8080:80 ub-18.04-php7.1-rbe apache2-foreground
#

FROM ubuntu:xenial
MAINTAINER Dolly Aswin <dolly.aswin@aqilix.com>

COPY apache2/zf3.vhost.conf /etc/apache2/sites-available/
COPY apache2/apache2-foreground /usr/local/bin
RUN apt-get -qq update
RUN apt-get install -y software-properties-common python-software-properties
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y \
    rsync \
    wget \
    curl \
    git \
    vim \
    apache2 \
    php7.1 \
    libapache2-mod-php7.1 \
    php7.1-intl \
    php7.1-curl \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-xml \
    php7.1-zip \
    php7.1-gd \
    php-redis \
    && mv /var/www/html /var/www/public \
    && curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer
RUN a2dissite 000-default \
    && a2enmod rewrite \
    && a2ensite zf3.vhost

RUN apt-get -y install libssl-dev
RUN apt-get -y install libsodium-dev
RUN apt-get -y install librabbitmq-dev
RUN apt-get -y install php-zmq
RUN apt-get -y install php-amqp

WORKDIR /var/www
EXPOSE 80
CMD ["apache2-foreground"]
