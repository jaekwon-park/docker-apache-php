FROM phusion/baseimage:latest

MAINTAINER Jaekwon Park <jaekwon.park@code-post.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Configure apt
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN echo "deb http://repo.suhosin.org/ ubuntu-trusty main" >> /etc/apt/sources.list.d/suhosin.list
RUN curl  https://sektioneins.de/files/repository.asc | apt-key add -
RUN apt-get -y update && \
    C_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 \
    python-software-properties software-properties-common \
    libapache2-mod-php7.1 php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-opcache php7.1-xml php7.1-xmlrpc php7.1-xsl php7.1-zip php7.1-readline php-memcache php-memcached php5-suhosin-extension&& \
    apt-get clean && rm -r /var/lib/apt/lists/*

# Configure apache module
RUN a2dismod mpm_event && \
    a2enmod mpm_prefork \
            ssl proxy proxy_http headers \
            rewrite && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

#RUN rm -rf /etc/apache2/sites-available/000-default.conf 
COPY 000-default.conf /etc/apache2/sites-available/
COPY default-ssl.conf /etc/apache2/sites-available/
COPY php.ini /etc/php/7.1/apache2/
COPY memcached.ini /etc/php/7.1/apache2/conf.d/20-memcache.ini

WORKDIR /var/www/html

COPY apache2-foreground /usr/local/bin/

EXPOSE 80

CMD ["apache2-foreground"]
