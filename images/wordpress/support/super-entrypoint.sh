#!/bin/bash

# test if $1 is "apache2-foreground", if so then fire it up, otherwise, assume the user wants
# to do something altogether different

/postfix-install.sh
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
