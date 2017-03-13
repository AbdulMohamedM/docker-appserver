#!/bin/bash

[ -f /run-pre.sh ] && /run-pre.sh

# Check that there is some configs for nginx to use
files=(/etc/nginx/conf.d/*.conf)
if [ ${#files[@]} -eq 0 ]; then
    echo "You must link your nginx conf using this with the docker run command:"
    echo "docker run ...  -v /yourapp/config/app.conf:/etc/nginx/conf.d/app.conf ..."
    exit 1
fi

# start php-fpm
php-fpm7 -R

# start nginx
mkdir -p /tmp/nginx
chown root /tmp/nginx
nginx
