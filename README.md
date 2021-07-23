# Nginx

[![Docker Pulls](https://img.shields.io/docker/pulls/jitesoft/nginx.svg)](https://cloud.docker.com/u/jitesoft/repository/docker/jitesoft/nginx)
[![Back project](https://img.shields.io/badge/Open%20Collective-Tip%20the%20devs!-blue.svg)](https://opencollective.com/jitesoft-open-source)

Nginx running on alpine linux.

## Tags

The image is built automatically via CI, using latest alpine as base image.

Images can be found at:

* [Docker hub](https://hub.docker.com/r/jitesoft/nginx): `jitesoft/nginx`  
* [GitLab](https://gitlab.com/jitesoft/dockerfiles/nginx): `registry.gitlab.com/jitesoft/dockerfiles/nginx`
* [GitHub](https://github.com/orgs/jitesoft/packages/container/package/nginx): `ghcr.io/jitesoft/nginx`
* [Quay](https://quay.io/jitesoft/nginx): `quay.io/jitesoft/nginx`  

## Dockerfile

Dockerfile can be found at [GitLab](https://gitlab.com/jitesoft/dockerfiles/nginx) and [GitHub](https://github.com/jitesoft/docker-nginx)

## Usage

Most basic usage is to just run the container, nginx will start and serve the content in the /usr/local/nginx/html directory.  
Port `80` is exposed by default.

### www-data user

The www-data user have the same id as the www-data user in the most common alpine images, 82.  
Before 2021 07 23, the id was 1000, which created issues with read/write permissions
when used with the jitesoft/php image.  

Containers created runs as root (easily changed in production with the appropriate flags),
while the nginx process runs as the www-data user (82) by default.

### Template

To ease the setup process, the startup script will generate a default.conf file in the /etc/nginx/conf.d directory. Any files in said directory will be
loaded into nginx by default.  
When the template is generated, the script will run `envsubstr` to replace all template vars with passed environment variables. If you wish to customise the template
you may create a new template and set the `CONF_TEMPLATE` variable to the path of the file and use `${VARIABLE}` placeholders to replace those with the
named env variables passed.

The default template file is located at `/usr/local/default.template` and exposes `LISTEN_PORT`, `SERVER_NAME` and `SERVER_ROOT` env variables and defaults to `80`, `localhost` and `/usr/local/nginx/html`.

It's also possible to change the full initial nginx configuration by replacing the `/etc/nginx/nginx.conf` file, while not recommended (rather create a new file to override in `/etc/nginx/conf.d`).

### Healthcheck

By default, the container will run a health check - via the `healthcheck` shell script - every 30 seconds.  
The health check script uses wget to hit a special endpoint (`127.0.0.1:3999/__health`), which is automatically created in the `/etc/nginx/conf.d/000-healthcheck.conf` configuration.  
It's possible to turn the healthcheck off by setting `SKIP_HEALTHCHECK=true` as an env variable. The healthcheck will still run, but always return as healthy.  
  
Changing the healthcheck scripts is possible, while not recommended.

## Licenses

Dockerfiles and other scripts in the repository is released under the [MIT license](https://gitlab.com/jitesoft/dockerfiles/nginx/blob/master/LICENSE)

Nginx is released under [2-clause BSD-like license](https://nginx.org/LICENSE).

## Image labels

This image follows the [Jitesoft image label specification 1.0.0](https://gitlab.com/snippets/1866155).

## Sponsors

Sponsoring is vital for the further development and maintaining of open source projects.  
Questions and sponsoring queries can be made via <a href="mailto:sponsor@jitesoft.com">email</a>.  
If you wish to sponsor our projects, reach out to the email above or visit any of the following sites:

[Open Collective](https://opencollective.com/jitesoft-open-source)  
[GitHub Sponsors](https://github.com/sponsors/jitesoft)  
[Patreon](https://www.patreon.com/jitesoft)

Jitesoft images are built via GitLab CI on runners hosted by the following wonderful organisations:

<a href="https://fosshost.org/">
  <img src="https://raw.githubusercontent.com/jitesoft/misc/master/sponsors/fosshost.png" width="256" alt="Fosshost logo" />
</a>

_The companies above are not affiliated with Jitesoft or any Jitesoft Projects directly._
