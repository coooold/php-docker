FROM alpine:latest
MAINTAINER coooold

ARG BUILD_DATE
ARG VCS_REF
ARG TIMEZONE=Asia/Shanghai
ARG IS_CN=y

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/coooold/php-docker.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="phpdev" \
      org.label-schema.name="php-docker" \
      org.label-schema.description="Docker for PHP developers" \
      org.label-schema.url="https://github.com/coooold/php-docker"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/8
# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

ARG DEPS="\
        php8 \
        php8-bcmath \
        php8-phar \
        php8-mbstring \
        php8-openssl \
        php8-zip \
        php8-shmop \
        php8-sockets \
        php8-curl \
        php8-simplexml \
        php8-xml \
        php8-opcache \
        php8-dom \
        php8-xmlreader \
        php8-xmlwriter \
        php8-tokenizer \
        php8-ctype \
        php8-session \
        php8-iconv \
        php8-json \
        php8-gd \
        php8-pdo \
        php8-pdo_mysql \
        php8-mysqli \
        php8-fpm \
        tzdata \
        curl \
        ca-certificates \
        runit \
        nginx \
"

RUN set -x \
    && if [ "${IS_CN}" = "y" ]; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; fi \
    && apk add --no-cache $DEPS \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone


COPY etc/nginx /

EXPOSE 80

CMD ["/sbin/runit-wrapper"]