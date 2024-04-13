set -ex
bash ./certbot/init-letsencrypt.sh localhost
bash ./mariadb/install.sh
bash ./wordpress/install.sh
bash ./nginx/install.sh
