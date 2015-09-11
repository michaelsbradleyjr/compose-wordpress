#!/bin/bash

mkdir -p /var/www/.ssh/keys

pub_keys="$(ls -A /docker-build/ssh-keys/*.pub 2>/dev/null)"
if [ -n "$pub_keys" ]; then
    cp /docker-build/ssh-keys/*.pub /var/www/.ssh/keys/
fi

chown -R www-data:www-data /var/www/.ssh
chmod 700 /var/www/.ssh
chmod 700 /var/www/.ssh/keys
if [ -n "$pub_keys" ]; then
    chmod -R 600 /var/www/.ssh/keys/*
fi
ln -s /var/www /home/www-data
