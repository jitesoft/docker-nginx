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
      com.jitesoft.app.nginx.version="${VERSION}" \
      # Open container labels
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_TIME}" \
      org.opencontainers.image.description="Nginx on Alpine linux" \
      org.opencontainers.image.vendor="Jitesoft" \
      org.opencontainers.image.source="https://gitlab.com/jitesoft/dockerfiles/nginx" \
      # Artifact hub annotations
      io.artifacthub.package.alternative-locations="oci://index.docker.io/jitesoft/nginx,oci://ghcr.io/jitesoft/nginx,oci://registry.gitlab.com/jitesoft/dockerfiles/nginx" \
      io.artifacthub.package.readme-url="https://gitlab.com/jitesoft/dockerfiles/nginx/-/raw/master/README.md" \
      io.artifacthub.package.logo-url="https://jitesoft.com/favicon-96x96.png"

ENV PORT="80"
ARG TARGETARCH
ARG WWWDATA_GUID="82"
ENV WWWDATA_GUID="${WWWDATA_GUID}"

RUN --mount=type=bind,source=./binaries,target=/tmp/bin \
    tar -xzhf /tmp/bin/nginx-${TARGETARCH}.tar.gz -C /usr/local \
 && cp /tmp/bin/default.template /usr/local/default.template \
 && adduser -u ${WWWDATA_GUID} -G www-data -s /bin/sh -D www-data \
 && mkdir -p /etc/nginx/conf.d /var/log/nginx /usr/local/nginx/html \
 && tar -xzhf /tmp/bin/nginx-conf-${TARGETARCH}.tar.gz -C /etc/nginx \
 && cp /tmp/bin/nginx.conf /etc/nginx/nginx.conf \
 && cp /tmp/bin/healthcheck.conf /etc/nginx/conf.d/000-healthcheck.conf \
 && chmod +x /usr/local/bin/* \
 && chown -R www-data:www-data /usr/local/nginx \
 && chown -R www-data:www-data /etc/nginx \
 && apk add --no-cache --virtual .runtime-deps openssl pcre zlib libxml2 libxslt gd geoip perl ca-certificates \
 && nginx -v

WORKDIR /usr/local/nginx/html

EXPOSE 80
VOLUME ["/etc/nginx/conf.d"]
ENTRYPOINT ["entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s CMD healthcheck
CMD ["nginx", "-g", "daemon off;"]
