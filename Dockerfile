FROM phusion/baseimage:0.9.15

MAINTAINER Jaekwon Park <jaekwon.park@code-post.com>

# Disable SSH
#RUN rm -rf /etc/service/sshd \
#           /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Configure apt
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get -y update && \
    C_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 \
    python-software-properties software-properties-common \
    php7.1 php7.1-cli php7.1-common \
    php7.1-curl php7.1-gd php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-opcache php7.1-xml php7.1-xmlrpc php7.1-xsl php7.1-zip php-memcach && \
    apt-get clean && rm -r /var/lib/apt/lists/*

# Configure apache module
RUN a2dismod mpm_event && \
    a2enmod mpm_prefork \
            rewrite && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

#RUN rm -rf /etc/apache2/sites-available/000-default.conf 
COPY 000-default.conf /etc/apache2/sites-available/
COPY php.ini /etc/php5/apache2/
COPY memcached.ini /etc/php5/mods-available/

WORKDIR /var/www/html

COPY apache2-foreground /usr/local/bin/

EXPOSE 80

CMD ["apache2-foreground"]
