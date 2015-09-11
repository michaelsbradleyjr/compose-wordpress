#!/bin/bash

# Adapted from:
# https://github.com/catatnight/docker-postfix

service postfix start
tail -f /var/log/mail.log
