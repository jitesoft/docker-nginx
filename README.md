# Nginx

Nginx running on alpine linux.

## Tags

The image is built automatically via CI, so the versions may change, but the CI script builds
the latest mainline and latest stable versions and uses latest alpine as base image.

### Docker Hub images

* `latest`, `mainline`, `1.7.x`
* `stable`, `1.6.x`

### GitLab images

* `registry.gitlab.com/jitesoft/dockerfiles/nginx`
  * `latest`, `mainline`, `1.7.x`
  * `stable`, `1.6.x`

### Quay.io images

* `quay.io/jitesoft/nginx`
  * `latest`, `mainline`, `1.7.x`
  * `stable`, `1.6.x`

Dockerfiles can be found at [GitLab](https://gitlab.com/jitesoft/dockerfiles/nginx) and [GitHub](https://github.com/jitesoft/docker-nginx)

## Usage

Most basic usage is to just run the container, nginx will start and serve the content in the /usr/local/nginx/html directory.  
Port `80` is exposed by default.

### Template

To ease the setup process, the startup script will generate a default.conf file in the /etc/nginx/conf.d directory. Any files in said directory will be
loaded into nginx by default.  
When the template is generated, the script will run `envsubstr` to replace all template vars with passed environment variables. If you wish to customise the template
you may create a new template and set the `CONF_TEMPLATE` variable to the path of the file and use `${VARIABLE}` placeholders to replace those with the
named env variables passed.

The default template file is located at `/usr/local/default.template` and exposes `LISTEN_PORT`, `SERVER_NAME` and `SERVER_ROOT` env variables and defaults to `80`, `localhost` and `/usr/local/nginx/html`.

## Licenses

Dockerfiles and other scripts in the repository is released under the [MIT license](https://gitlab.com/jitesoft/dockerfiles/nginx/blob/master/LICENSE)

Nginx is released under [2-clause BSD-like license](https://nginx.org/LICENSE).

## Image labels

This image follows the [Jitesoft image label specification 1.0.0](https://gitlab.com/snippets/1866155).
