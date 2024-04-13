#!/bin/sh
set -ex

CONTAINER_NAME=$(docker ps -aqf "name=wordpress")
DATE=$(date +'%y.%m.%d-%H.%M.%S'.sql)

docker exec $CONTAINER_NAME wp db export $DATE

docker cp $CONTAINER_NAME:/var/www/wordpress/$DATE srcs/requirements/wordpress/sql
