#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091
set -euo pipefail

source ./gke_functions.sh

log "Configuring gcloud cli for cluster: ${GKE_CLUSTER_NAME}..."
$(config_gcloud)

log "Configuring local kubectl..."
$(config_kubectl)

log "Deleting GKE cluster: ${GKE_CLUSTER_NAME}"
$(gke_delete)
log "${GKE_CLUSTER_NAME} scheduled for deletion (~20 min.)"
