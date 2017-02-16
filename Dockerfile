FROM alpine:3.5

RUN echo "fs.file-max = 65535" > /etc/sysctl.conf

# Install
RUN apk update && apk upgrade \
    && apk add \
        bash jq curl vim ca-certificates s6 ssmtp \
        php7 php7-phar php7-curl php7-fpm php7-json php7-zlib php7-xml php7-dom php7-ctype \
        php7-opcache php7-zip php7-iconv php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-pdo_pgsql \
        php7-mbstring php7-session php7-gd php7-mcrypt php7-openssl php7-sockets php7-posix \
        php7-ldap php7-mysqli php7-soap php7-apcu php7-gmp php7-pgsql \
        php7-ftp php7-gettext nginx nginx-mod-http-lua
#    && apk add -U nginx-lua@edge

# fix php7-fpm "Error relocating /usr/bin/php7-fpm: __flt_rounds: symbol not found" bug
RUN apk add -u musl
RUN rm -rf /var/cache/apk/*

# Shell Fix
RUN echo "/bin/bash" >> /etc/shells
RUN sed -i -- 's/bin\/ash/bin\/bash/g' /etc/passwd
ADD env/.bashrc /root/

# Nginx
ADD nginx/nginx.conf /etc/nginx/
ADD php/php-fpm.conf /etc/php7/
RUN rm -rf /var/www/* && mkdir -p /etc/nginx/conf.d /var/app /run/nginx /tmp/nginx/fastcgi_temp /tmp/nginx/body /var/run/php7-fpm

# entry
ADD scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD [ "/entrypoint.sh" ]
