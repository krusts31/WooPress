up-store-dev:
	bash ./srcs/requirements/single-site-store/certbot/init-letsencrypt.sh store-dev.com
	docker compose -f srcs/single-site-store/docker-compose-store-dev.yaml\
		--env-file srcs/signle-site-store/.env-store-dev up --build

down-store-dev:
	docker compose -f srcs/signle-site-store/docker-compose-store-dev.yaml\
		--env-file srcs/signle-site-store/.env-store-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

up-multi-dev:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh\
		bio113-dev.com lt.bio113-dev.com et.bio113-dev.com\
		lv.bio113-dev.com de.bio113-dev.com files.bio113-dev.com
	docker compose -f srcs/multi-site-store/docker-compose-multi-site-dev.yaml\
		--env-file srcs/.env-dev up --build

up-multi-prod:
	bash ./srcs/requirements/certbot/init-letsencrypt.sh\
		olgrounds.dev lt.olgrounds.dev et.olgrounds.dev\
		lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	docker compose -f srcs/multi-site-store/docker-compose-multi-site-prod.yaml\
		--env-file srcs/multi-site-store/.env-prod up --build -d
	bash ./srcs/tools/wait.sh
	bash ./srcs/multi-site-store/requirements/certbot/prod-cert-letsncrypt.sh\
		olgrounds.dev lt.olgrounds.dev et.olgrounds.dev\
		lv.olgrounds.dev de.olgrounds.dev files.olgrounds.dev
	#bash ./srcs/cert/bottest_renew.sh TODO
	bash ./srcs/tools/reload_nginx.sh

down-multi-prod:
	docker compose -f srcs/multi-site-store/docker-compose-multi-site-prod.yaml\
		--env-file srcs/multi-site-store/.env-prod -v down 
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

down-multi-dev:
	docker compose -f srcs/multi-site-store/docker-compose-multi-site-dev.yaml\
		--env-file srcs/multi-site-store/.env-dev -v down
	docker volume rm srcs_vol_mariadb srcs_vol_wordpress

save:
	bash ./srcs/tools/database_backup.sh

import:
	bash ./srcs/tools/import_database.sh 24.04.07-12.40.34.sql

stop:
	docker stop -t 0 $(shell docker ps -q)
