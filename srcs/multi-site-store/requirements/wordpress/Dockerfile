FROM alpine:edge as base

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories &&\
	apk update && apk upgrade && apk add --no-cache\
	php83\
	php83-simplexml\
	php83-tokenizer\
	php83-xmlwriter\
	php83-ctype\
	php83-phar\
	php83-openssl\
	php83-curl\
	php83-dom\
	php83-exif\
	php83-fileinfo\
	php83-sodium\
	php83-mbstring\
	php83-mysqli\
	php83-xml\
	php83-zip\
	php83-cgi\
	php83-pecl-imagick\
	php83-fpm\
	php83-session\
	php83-gd\
	php83-iconv\
	php83-intl\
	mariadb-client\
	tini

RUN ln -s /usr/bin/php83 /usr/local/bin/php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN adduser -S nginx &&\
	addgroup -S nginx

RUN chmod +x wp-cli.phar &&\
	mv wp-cli.phar /usr/bin/wp

WORKDIR /var/www/wordpress

COPY --chown=nginx:nginx ./php83-conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY --chown=nginx:nginx ./php83-conf/php.ini /etc/php83/php.ini

COPY --chown=nginx:nginx ./lang/ /tmp/lang/

COPY --chown=nginx:nginx ./csv/products/ /tmp/products/
COPY --chown=nginx:nginx ./csv/categories/ /tmp/categories/
COPY --chown=nginx:nginx ./omniva-woocommerce/ /tmp/omniva-woocommerce/

COPY --chown=nginx:nginx ./create_products.php /tmp/create_products.php
COPY --chown=nginx:nginx ./create_initial_categoires.php /tmp/create_initial_categoires.php
COPY --chown=nginx:nginx ./replace_old_ids_in_products.php /tmp/replace_old_ids_in_products.php
COPY --chown=nginx:nginx ./update_cat_id.php /tmp/update_cat_id.php
COPY --chown=nginx:nginx ./functions.php /tmp/functions.php

COPY --chown=nginx:nginx ./sql /tmp/sql

COPY --chown=nginx:nginx health-checks/healthcheck.sh /tmp/healthcheck.sh

ENTRYPOINT ["tini", "--"]

FROM base as plugin-dev

RUN apk add --no-cahce php83-ctype\
	php83-tokenizer\
	php83-xmlwriter\
	subversion\
	composer\
	git\
	bash\
	phpunit\
	openssh-client

COPY --chown=nginx:nginx init-scripts/plugin-dev-install.sh /tmp/plugin-dev-install.sh

CMD sh /tmp/plugin-dev-install.sh

FROM base as store-dev

COPY --chown=nginx:nginx init-scripts/store-wordpress-install.sh /tmp/store-wordpress-install.sh

CMD sh /tmp/store-wordpress-install.sh

FROM base as blog-dev

COPY --chown=nginx:nginx init-scripts/blog-wordpress-install.sh /tmp/blog-wordpress-install.sh

CMD sh /tmp/blog-wordpress-install.sh

FROM base as single-site-dev

COPY --chown=nginx:nginx init-scripts/core-wordpress-install.sh /tmp/core-wordpress-install.sh

CMD sh /tmp/core-wordpress-install.sh

FROM base as multi-site-dev

RUN apk add vim --no-cache

COPY --chown=nginx:nginx init-scripts/multi-site-dev-wordpress-install.sh /tmp/multi-site-wordpress-install.sh

CMD sh /tmp/multi-site-wordpress-install.sh

FROM base as multi-site-prod

COPY --chown=nginx:nginx init-scripts/multi-site-prod-wordpress-install.sh /tmp/multi-site-wordpress-install.sh

CMD sh /tmp/multi-site-wordpress-install.sh
