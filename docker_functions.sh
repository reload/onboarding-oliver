#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2143,SC2034
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

create_networks(){
  docker network create \
    "${network}"
}

create_volumes(){
  docker volume create \
    "${volume}"
}

run_todo_app(){
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

run_todo_db(){
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
