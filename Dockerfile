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
COPY entrypoint /usr/local/bin/

ENV PATH="/usr/local/nginx/sbin:${PATH}"

RUN addgroup -g 1000 nginx \
 && adduser -u 1000 -G nginx -s /bin/sh -D nginx \
 && apk add --no-cache --virtual .build-deps build-base \
 && apk add --no-cache openssl-dev pcre-dev zlib-dev ca-certificates \
 && mkdir -p /tmp/nginx-src /var/log/nginx /usr/local/nginx \
 && tar -xzf /tmp/nginx.tar.gz -C /tmp/nginx-src --strip-components=1 \
 && rm -f /tmp/nginx.tar.gz \
 && cd /tmp/nginx-src/ \
 && ./configure --with-http_ssl_module --with-http_gzip_static_module --user=nginx --group=nginx --error-log-path=/var/log/nginx --http-log-path=/var/log/nginx --prefix=/usr/local/nginx \
 && make -j2 \
 && make install \
 && apk del .build-deps \
 && nginx -v

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["entrypoint"]
CMD ["nginx", "-g", "daemon off;"]


