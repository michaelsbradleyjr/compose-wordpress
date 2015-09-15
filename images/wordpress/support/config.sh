#!/bin/bash

apt-get update
apt-get -y install \
        libmcrypt-dev \
        libtidy-dev \
        postfix \
        rsyslog \
        supervisor \
        unzip \
        zip

support_scripts=(
    apache2-foreground.sh
    postfix.sh
    postfix-install.sh
    super-entrypoint.sh
)
for ss in ${support_scripts[@]}; do
    cp /docker-build/support/$ss /$ss
    chmod 755 /$ss
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
    sd_files="$(ls -A /support/$sd/* 2>/dev/null)"
    for sdf in ${sd_files[@]}; do
        chmod 644 $sdf
    done
done

if [[ (! -e /docker-build/ssl/ssl.key) || \
         (! -e /docker-build/ssl/ssl.crt) ]]; then
    openssl req \
            -new \
            -newkey rsa:2048 \
            -days 365 \
            -nodes \
            -x509 \
            -subj "/C=US/ST=State/L=City/O=Org/CN=example.com" \
            -keyout /docker-build/ssl/ssl.key \
            -out /docker-build/ssl/ssl.crt
fi
chmod 440 /docker-build/ssl/*.key
chown root:ssl-cert /docker-build/ssl/*.key
chmod 444 /docker-build/ssl/*.crt
cp /docker-build/ssl/*.key /etc/ssl/private
cp /docker-build/ssl/*.crt /etc/ssl/certs

a2enmod expires headers ssl

mkdir -p /docker-build/temp
cd /docker-build/temp
curl -O http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz
tar xvzf xcache-3.2.0.tar.gz
find . -type d -exec chmod 0755 {} \;
find . -type f -exec chmod 0644 {} \;
mv xcache-3.2.0 /usr/src/php/ext/xcache
cd -
docker-php-ext-install \
    mbstring \
    mcrypt \
    tidy \
    opcache \
    xcache \
    zip
cat /docker-build/support/xcache.ini > /usr/local/etc/php/conf.d/docker-php-ext-xcache.ini

cat /docker-build/support/apache2.conf.append >> /etc/apache2/apache2.conf
confs_ava="$(ls -A /docker-build/sites-available/*.conf 2>/dev/null)"
confs_ena="$(ls -A /docker-build/sites-enabled/*.conf 2>/dev/null)"
for ca in ${confs_ava[@]}; do
    cp $ca /etc/apache2/sites-available
done
for ce in ${confs_ena[@]}; do
    ceb=$(basename "$ce" .conf)
    a2ensite $ceb
done
