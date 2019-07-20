# -user -group -build=(name) --error-log-path=/var/log/nginx
FROM registry.gitlab.com/jitesoft/dockerfiles/alpine:latest
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/php/issues" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/php"

COPY ./nginx.tar.gz /tmp/nginx.tar.gz
COPY ./entrypoint /usr/local/bin/

ENV PATH="/usr/local/nginx/sbin:${PATH}"

RUN addgroup -g 1000 www-data \
 && adduser -u 1000 -G www-data -s /bin/sh -D www-data \
 && apk add --no-cache --virtual .build-deps build-base \
 && apk add --no-cache openssl-dev pcre-dev zlib-dev libxml2-dev libxslt-dev gd-dev geoip-dev perl-dev ca-certificates \
 && mkdir -p /tmp/nginx-src /var/log/nginx /usr/local/nginx \
 && tar -xzf /tmp/nginx.tar.gz -C /tmp/nginx-src --strip-components=1 \
 && rm -f /tmp/nginx.tar.gz \
 && cd /tmp/nginx-src/ \
 && apk add --no-cache \
 && ./configure \
    --user=www-data \
    --group=www-data \
    --conf-path=/etc/nginx.conf \
    --with-http_addition_module \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module \
    --with-http_perl_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_xslt_module \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-pcre-jit \
    --error-log-path=/var/log/nginx/err.log \
    --http-log-path=/var/log/nginx/http.log \
    --prefix=/usr/local/nginx \
 && make -j2 \
 && make install \
 && cd / \
 && rm -rf /tmp/nginx-src \
 && apk del .build-deps \
 && chown -R www-data:www-data /usr/local/nginx \
 && chown -R www-data:www-data /usr/local/bin \
 && chmod +x /usr/local/bin/entrypoint \
 && nginx -v

WORKDIR /usr/local/nginx/html

EXPOSE 80
VOLUME ["/etc/nginx/conf.d", "/usr/local/nginx/html"]
ENTRYPOINT ["entrypoint"]
CMD ["nginx", "-g", "daemon off;"]


