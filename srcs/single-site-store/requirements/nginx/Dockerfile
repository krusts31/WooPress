FROM alpine:latest as base

RUN apk update &&\
	apk upgrade &&\
	apk add --no-cache\
	nginx

RUN mkdir -p /run/nginx

RUN rm /etc/nginx/http.d/default.conf

COPY --chown=nginx:nginx healthcheck.sh /tmp/healthcheck.sh

COPY --chown=nginx:nginx conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]

FROM base as store-dev

COPY --chown=nginx:nginx conf/blog.conf /etc/nginx/http.d/store.conf

FROM base as blog-dev

COPY --chown=nginx:nginx conf/blog.conf /etc/nginx/http.d/blog.conf

FROM base as single-site-dev

COPY --chown=nginx:nginx conf/prod.conf /etc/nginx/http.d/prod.conf

FROM base as multi-site-dev

COPY --chown=nginx:nginx conf/wordpress-multi-site-dev.conf /etc/nginx/http.d/wordpress-multi-site-dev.conf

FROM base as multi-site-staging

COPY --chown=nginx:nginx conf/wordpress-multi-site-staging.conf /etc/nginx/http.d/wordpress-multi-site-staging.conf

FROM base as multi-site-prod

COPY --chown=nginx:nginx conf/wordpress-multi-site-prod.conf /etc/nginx/http.d/wordpress-multi-site-prod.conf
