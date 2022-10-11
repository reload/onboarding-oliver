#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2143
set -euo pipefail

# Network array - to add more, separate by space and double qoutes e.g. "todo-app" "your-second-network"
networks=("todo-app")
# Volume array - to add more, separate by space and double qoutes, e.g. "todo-mysql-data" "your-second-volume"
volumes=("todo-mysql-data" "lol")
# Path to docker images
images="${PWD}/docker/images"
# Set app container name
app="todo-app"
# Set db container name
db="todo-db"

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
    --volume "${images}/getting-started/app:/app" \
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
    --name "${db}"
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
  if [ "$(docker network ls | grep "${network}")" ]; then
    log "${network} exists, skipping..."
  else
    OUTPUT=$(networks)
    log "Network ${network} created"
  fi
done

# Create volumes for containers
log "Checking for existing volumes..."
for volume in "${volumes[@]}"
do
  if [ "$(docker volume ls -q | grep "${volume}")" ]; then
    log "${volume} exists, skipping..."
  else
    OUTPUT=$(volumes)
    log "Volume ${volume} created"
  fi
done

# Spawn todo list node.js app
if [ "$(docker ps -a | grep "${app}")" ]; then
  # cleanup
  log "Existing ${app} container found - nuking & re-spawning it"
  docker rm -f "${app}"
  OUTPUT=$(todo_app)
else
  log "Spawning ${app} container"
  OUTPUT=$(todo_app)
fi

# Spawn todo list database
if [ "$(docker ps -a | grep "${db}")" ]; then
  # cleanup
  log "Existing ${db} container found - nuking & re-spawning it"
  docker rm -f "${db}"
  OUTPUT=$(todo_db)
else
  log "Spawning ${db} container"
  OUTPUT=$(todo_db)
fi
