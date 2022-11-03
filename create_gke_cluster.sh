#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091
set -euo pipefail

source ./gke_functions.sh

log "Configuring gcloud cli for cluster: ${GKE_CLUSTER_NAME}..."
config_gcloud

log "Creating GKE cluster: ${GKE_CLUSTER_NAME}"
gke_create
log "${GKE_CLUSTER_NAME} scheduled for creation (~20 min.)"
log "Remember to configure kubectl locally when cluster is available using: gcloud container clusters get-credentials ${GKE_CLUSTER_NAME}"
