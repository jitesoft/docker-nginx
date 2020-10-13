# syntax=docker/dockerfile:experimental
FROM registry.gitlab.com/jitesoft/dockerfiles/alpine:latest
ARG VERSION
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/nginx" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/nginx/issues" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/nginx" \
      com.jitesoft.app.nginx.version="${VERSION}"

ENV PORT="80"
ARG TARGETARCH

RUN --mount=type=bind,source=./binaries,target=/tmp/bin \
    tar -xzhf /tmp/bin/nginx-${TARGETARCH}.tar.gz -C /usr/local \
 && cp /tmp/bin/nginx.conf /etc/nginx.conf \
 && cp /tmp/bin/default.template /usr/local/default.template \
 && addgroup -g 1000 www-data \
 && adduser -u 1000 -G www-data -s /bin/sh -D www-data \
 && mkdir -p /tmp/nginx-src /var/log/nginx /usr/local/nginx/html \
 && chmod +x /usr/local/bin/* \
 && chown -R www-data:www-data /usr/local/nginx \
 && chown www-data:www-data /etc/nginx.conf \
 && apk add --no-cache --virtual .runtime-deps openssl pcre zlib libxml2 libxslt gd geoip perl ca-certificates \
 && nginx -v

WORKDIR /usr/local/nginx/html

EXPOSE 80
VOLUME ["/etc/nginx/conf.d"]
ENTRYPOINT ["entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s CMD healthcheck
CMD ["nginx", "-g", "daemon off;"]
