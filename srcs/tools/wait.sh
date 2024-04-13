#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Use docker compose -f ./../docker-compose.yaml to check the health status of all services
healthy_count=$(docker compose -f $DIR/../docker-compose-prod.yaml --env-file $DIR/../.env-prod ps | grep 'healthy' | wc -l)
unhealthy_count=$(docker compose -f $DIR/../docker-compose-prod.yaml --env-file $DIR/../.env-prod ps | grep 'unhealthy' | wc -l)

# Wait until all 3 containers are healthy or one becomes unhealthy
while [[ $healthy_count -lt 3 && $unhealthy_count -eq 0 ]]; do
    echo "Waiting for all containers to be healthy..."
    docker compose -f $DIR/../docker-compose-prod.yaml --env-file $DIR/../.env-prod ps
    sleep 5

    healthy_count=$(docker compose -f $DIR/../docker-compose-prod.yaml --env-file $DIR/../.env-prod  ps | grep 'healthy' | wc -l)
    unhealthy_count=$(docker compose -f $DIR/../docker-compose-prod.yaml --env-file $DIR/../.env-prod  ps | grep 'unhealthy' | wc -l)
done

# Check if any container is unhealthy and abort
if [ $unhealthy_count -gt 0 ]; then
    echo "One or more containers are unhealthy. Aborting."
    exit 1
fi

echo "All containers are healthy!"

