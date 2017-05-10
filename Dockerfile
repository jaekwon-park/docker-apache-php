FROM phusion/baseimage:0.9.15

MAINTAINER Jaekwon Park <jaekwon.park@code-post.com>

# Disable SSH
#RUN rm -rf /etc/service/sshd \
#           /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Configure apt
RUN apt-get -y update && \
    C_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 \
    libapache2-mod-php5 \
    php5 php5-cli php5-fpm php5-common php5-curl php5-ldap php5-json php5-mysql php5-memcached && \
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
