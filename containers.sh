#!/usr/bin/env bash
set -euo pipefail

images="${PWD}/docker/images"

log(){
  echo "$(date +'%T') $1"
}

networks(){
  docker network create \
    todo-app
}

volumes(){
  docker volume create \
    todo-mysql-data
}

todo_app(){
  docker run \
    --detach \
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
    --network todo-app \
    --network-alias mysql \
    --volume todo-mysql-data:/var/lib/mysql \
    --env MYSQL_ROOT_PASSWORD=secret \
    --env MYSQL_DATABASE=todos \
     mysql:5.7
}

# Create networks for containers
log "Creating docker networks..."
OUTPUT=$(networks)

# Create volumes for containers
log "Creating docker volumes..."
OUTPUT=$(volumes)

# Spawn todo-list node.js app container
log "Spawning todo app container..."
OUTPUT=$(todo_app)

# Spawn todo-list database
log "Spawning todo database..."
OUTPUT=$(todo_db)
