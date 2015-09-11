#!/bin/bash

apt-get update
apt-get -y install \
        php-mime-type \
        php5-mcrypt \
        php5-tidy \
        php5-xcache \
        postfix \
        rsyslog \
        supervisor \
        unzip \
        zip

# may not need the following, per build system of docker php image
# libapache2-mod-php5 \

support_scripts=(
    apache2-foreground.sh
    postfix.sh
    postfix-install.sh
    super-entrypoint.sh
)
for ss in ${support_scripts[@]}; do
    cp /docker-build/support/$ss /$ss
    chmod 754 /$ss
    ln -s /$ss /usr/local/bin/$ss
done
ln -s /entrypoint.sh /usr/local/bin/entrypoint.sh

mkdir -p /support
support_files=(
    dot.htaccess
    supervisord.conf
)
for sf in ${support_files[@]}; do
    cp /docker-build/support/$sf /support/$sf
    chmod 644 /support/$sf
done

support_dirs=(
    plugins
    themes
)
for sd in ${support_dirs[@]}; do
    cp -R /docker-build/$sd /support/$sd
    chmod 755 /support/$sd
    chmod 644 /support/$sd/*
done

if [ (! -e /docker-build/support/ssl/ssl.key) || \
         (! -e /docker-build/support/ssl/ssl.crt) ]; then
    openssl req \
            -new \
            -newkey rsa:2048 \
            -days 365 \
            -nodes \
            -x509 \
            -subj "/C=US/ST=State/L=City/O=Org/CN=example.com" \
            -keyout /docker-build/support/ssl/ssl.key \
            -out /docker-build/support/ssl/ssl.crt
fi
addgroup --system 'ssl-cert'
chmod 440 /docker-build/support/ssl/*.key
chown root:ssl-cert /docker-build/support/ssl/*.key
chmod 444 /docker-build/support/ssl/*.crt
cp /docker-build/support/ssl/*.key /etc/ssl/private
cp /docker-build/support/ssl/*.crt /etc/ssl/certs

a2enmod expires headers ssl

confs_ava="$(ls -A /docker-build/sites-available/*.conf 2>/dev/null)"
confs_ena="$(ls -A /docker-build/sites-enabled/*.conf 2>/dev/null)"
for ca in ${confs_ava[@]}; do
    cp $ca /etc/apache2/sites-available
done
for ce in ${confs_ena[@]}; do
    ceb=$(basename "$ce" .conf)
    a2ensite $ceb
done
