#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2143
set -euo pipefail

## vars ##

# Path to docker images
images_path="${PWD}/docker/images"
# app container name
app="todo-app"
# db container name
db="todo-db"

# arrays #

# Network - to add more, separate by space and double qoutes e.g. "todo-app" "your-second-network"
networks=("todo-app")
# Volume - to add more, separate by space and double qoutes, e.g. "todo-mysql-data" "your-second-volume"
volumes=("todo-mysql-data")

log(){
  echo "$(date +'%T') $1"
}

networks(){
  docker network create \
    "${network}"
}

volumes(){
  docker volume create \
    "${volume}"
}

todo_app(){
  docker run \
    --detach \
    --name "${app}" \
    --publish 3000:3000 \
    --workdir "/app" \
    --volume "${images_path}/getting-started/app:/app" \
    --network todo-app \
    --env MYSQL_HOST=mysql \
    --env MYSQL_USER=root \
    --env MYSQL_PASSWORD=secret \
    --env MYSQL_DB=todos \
    node:18-alpine \
    sh -c "yarn install && yarn run dev"
}

todo_db(){
  docker run \
    --detach \
    --name "${db}" \
    --network todo-app \
    --network-alias mysql \
    --volume todo-mysql-data:/var/lib/mysql \
    --env MYSQL_ROOT_PASSWORD=secret \
    --env MYSQL_DATABASE=todos \
     mysql:5.7
}

# Create networks for containers
log "Checking for existing networks..."
for network in "${networks[@]}"
do
  if [ "$(docker network ls | grep -w "${network}")" ]; then
    log "Network ${network} exists, skipping..."
  else
    OUTPUT=$(networks)
    log "Network ${network} created"
  fi
done

# Create volumes for containers
log "Checking for existing volumes..."
for volume in "${volumes[@]}"
do
  if [ "$(docker volume ls -q | grep -w "${volume}")" ]; then
    log "Volume ${volume} exists, skipping..."
  else
    OUTPUT=$(volumes)
    log "Volume ${volume} created"
  fi
done

# Spawn todo list node.js app
if [ "$(docker ps -a | grep -w "${app}")" ]; then
  # cleanup
  log "Existing ${app} container found - nuking & re-spawning it"
  docker rm -f "${app}" > /dev/null
  OUTPUT=$(todo_app)
else
  log "Spawning ${app} container"
  OUTPUT=$(todo_app)
fi

# Spawn todo list database
if [ "$(docker ps -a | grep -w "${db}")" ]; then
  # cleanup
  log "Existing ${db} container found - nuking & re-spawning it"
  docker rm -f "${db}" > /dev/null
  OUTPUT=$(todo_db)
else
  log "Spawning ${db} container"
  OUTPUT=$(todo_db)
fi
