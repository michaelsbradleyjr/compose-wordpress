#!/bin/bash
set -e

if [[ "$1" == apache2* ]]; then
    /postfix-install.sh
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else
    exec "$@"
fi
