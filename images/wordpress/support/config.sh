#!/bin/bash

apt-get update
apt-get -y install \
        libapache2-mod-php5 \
        php-mime-type \
        php5-mcrypt \
        php5-tidy \
        php5-xcache \
        postfix \
        rsyslog \
        supervisor \
        unzip \
        zip

cp /docker-build/support/apache2-foreground.sh /apache2-foreground.sh
cp /docker-build/support/postfix.sh /postfix.sh
cp /docker-build/support/postfix-install.sh /postfix-install.sh
cp /docker-build/support/super-entrypoint.sh /super-entrypoint.sh

ln -s /apache2-foreground.sh /usr/local/bin/apache2-foreground.sh
ln -s /entrypoint.sh /usr/local/bin/entrypoint.sh
ln -s /postfix.sh /usr/local/bin/postfix.sh
ln -s /postfix-install.sh /usr/local/bin/postfix-install.sh
ln -s /super-entrypoint.sh /usr/local/bin/super-entrypoint.sh

mkdir -p /support
cp /docker-build/support/dot.htaccess /support/dot.htaccess
cp /docker-build/support/supervisord.conf /support/supervisord.conf

cp -R /docker-build/plugins /support/plugins
cp -R /docker-build/themes /support/themes

confs="$(ls -A /docker-build/sites-enabled/*.conf)"

[ "$confs" ] && cp /docker-build/sites-enabled/*.conf /etc/apache2/sites-available

# for c in ~/projects/*.c; do
#     test -f "$z" || continue
#     echo "Working on $z C program..."
# done

a2enmod ssl
a2ensite wordpress-ssl.conf
