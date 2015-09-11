#!/bin/bash

# Adapted from:
# https://github.com/catatnight/docker-postfix

# ---------
# judgement
# ---------
if [ -e /etc/supervisor/conf.d/supervisord.conf ]; then
  exit 0
fi

# ----------
# supervisor
# ----------
cp /support/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# -------
# postfix
# -------
maildomain=$WP_MAIL_DOMAIN
if [ -z "$maildomain" ]; then
    maildomain="mail.example.com"
fi
mailorigin=$WP_MAIL_ORIGIN
if [ -z "$mailorigin" ]; then
    mailorigin="example.com"
fi
echo "root,wordpress" > /etc/postfix/canonical
echo "www-data,wordpress" >> /etc/postfix/canonical
chmod 644 /etc/postfix/canonical
postconf -e canonical_maps=hash:/etc/postfix/canonical
postconf -e inet_interfaces=localhost
postconf -e masquerade_domains=$mailorigin
postcont -e mydestination="localhost, localhost.localdomain, localhost"
postconf -e myhostname=$maildomain
postconf -e mynetworks="127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"
postconf -e myorigin=$mailorigin
postconf -F '*/*/chroot = n'
