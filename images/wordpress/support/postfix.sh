#!/bin/bash

# Adapted from:
# https://github.com/catatnight/docker-postfix

service postfix start
tail -f -q --retry \
     /var/log/mail.err \
     /var/log/mail.info \
     /var/log/mail.log \
     /var/log/mail.warn
