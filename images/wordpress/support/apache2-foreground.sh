#!/bin/bash

if [ ! -e /var/www/html/.ht_post_entrypoint_setup ]; then
    cat /support/dot.htaccess >> /var/www/html/.htaccess

    plugins="$(ls -A /support/plugins/*.zip 2>/dev/null)"
    themes="$(ls -A /support/themes/*.zip 2>/dev/null)"
    for p in ${plugins[@]}; do
        unzip $p -d /var/www/html/wp-content/plugins
    done
    for t in ${themes[@]}; do
        unzip $t -d /var/www/html/wp-content/themes
    done
    chown -R www-data:www-data /var/www/html/wp-content/plugins
    chown -R www-data:www-data /var/www/html/wp-content/themes

    touch /var/www/html/.ht_post_entrypoint_setup
    chown www-data:www-data /var/www/html/.ht_post_entrypoint_setup
    chmod 644 /var/www/html/.ht_post_entrypoint_setup
    echo "automatically created by /apache2-foreground.sh, do not delete" \
         >> /var/www/html/.ht_post_entrypoint_setup
fi

exec apache2-foreground
