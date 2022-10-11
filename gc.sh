#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1091
set -euo pipefail

source ./containers.sh

# Check container logs return OK
log "Verifying container functionality..."
# Give containers a moment to start
sleep 30
docker logs "${app}" 2>&1 | grep "Listening on port 3000"
docker logs "${db}" 2>&1 | grep "mysqld: ready for connections"

# Cleanup containers
  log "Removing containers: ${app} ${db}"
  docker rm -f "${app}" "${db}" > /dev/null

# Cleanup networks
for network in "${networks[@]}"
do
    log "Removing network ${network}"
    docker network rm "${network}" > /dev/null
done

# Cleanup volumes
for volume in "${volumes[@]}"
do
    log "Removing volume ${volume}"
    docker volume rm "${volume}" > /dev/null
done
