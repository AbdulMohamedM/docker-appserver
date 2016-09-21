FROM justcontainers/base-alpine

# Update Alpine Package list
RUN apk update
RUN apk upgrade

RUN echo "@edge http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "fs.file-max = 65535" > /etc/sysctl.conf

# Install
RUN apk update \
    && apk add bash jq curl vim ca-certificates \
    php5-fpm php5-json php5-zlib php5-xml php5-pdo php5-phar php5-openssl \
    php5-pdo_mysql php5-mysqli php5-cli php5-ctype php5-curl \
    php5-gd php5-iconv php5-mcrypt php5-soap php5-apcu php5-gmp \
    php5-pgsql php5-pdo_pgsql php5-ftp php5-gettext php5-dom \
    && apk add -U nginx-lua@edge

# fix php5-fpm "Error relocating /usr/bin/php5-fpm: __flt_rounds: symbol not found" bug
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

CMD [ "/entrypoint.sh" ]
