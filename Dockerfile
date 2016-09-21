FROM justcontainers/base-alpine

# Update Alpine Package list
RUN apk update
RUN apk upgrade

RUN echo "@edge http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "fs.file-max = 65535" > /etc/sysctl.conf

# Install
RUN apk update \
    && apk add bash jq curl vim ca-certificates \
    php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
    php-pdo_mysql php-mysqli php-cli php-ctype php-curl \
    php-gd php-iconv php-mcrypt php-soap php-apcu php-gmp \
    php-pgsql php-pdo_pgsql php-ftp php-gettext php-dom \
    && apk add -U nginx-lua@edge

# fix php-fpm "Error relocating /usr/bin/php-fpm: __flt_rounds: symbol not found" bug
RUN apk add -u musl
RUN rm -rf /var/cache/apk/*

# Shell Fix
RUN echo "/bin/bash" >> /etc/shells
RUN sed -i -- 's/bin\/ash/bin\/bash/g' /etc/passwd
ADD env/.bashrc /root/

# Nginx
ADD nginx/nginx.conf /etc/nginx/
ADD php/php-fpm.conf /etc/php/
RUN mkdir -p /etc/nginx/conf.d /var/app

# entry
ADD scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh
EXPOSE 80

CMD [ "/entrypoint.sh" ]

