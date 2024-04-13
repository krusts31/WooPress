#!/bin/bash

# Your Docker container names
CONTAINERS=("srcs-nginx" "srcs-mariadb" "srcs-wordpress")  # Add your container names here

#TODO remove this from git its probably a secret! :D
##https://discordapp.com/api/webhooks/SECRET/SECRET
#WEBHOOK_URL=""

# Loop through each container to check its status
for CONTAINER in "${CONTAINERS[@]}"; do
    docker inspect  $CONTAINER

    sleep 4
   # if [ "$STATUS" != "running" ]; then
   #     curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"🚨 Container $CONTAINER has status: $STATUS 🚨\"}" $WEBHOOK_URL
   # elif [ -n "$HEALTH" ] && [ "$HEALTH" != "healthy" ]; then
   #     curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"🚨 Container $CONTAINER is not healthy: $HEALTH 🚨\"}" $WEBHOOK_URL
   # fi
done

