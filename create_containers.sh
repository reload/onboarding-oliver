#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2143,SC2034,SC1091
set -euo pipefail

source ./docker_functions.sh

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
