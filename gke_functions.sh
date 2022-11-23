#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

source ./google_vars.sh

log(){
  echo "$(date +'%T') $1"
}

config_gcloud(){
  gcloud config set project "${GCP_PROJECT_ID}"
  gcloud config set compute/region "${GCP_REGION}"
  gcloud config set container/cluster "${GKE_CLUSTER_NAME}"
}

config_kubectl(){
  gcloud container clusters get-credentials "${GKE_CLUSTER_NAME}" \
    --region "${GCP_REGION}"
}

gke_create(){
  gcloud container clusters create "${GKE_CLUSTER_NAME}" \
    --async \
    --cluster-version="${GKE_CLUSTER_VER}" \
    --enable-intra-node-visibility \
    --no-enable-master-authorized-networks \
    --machine-type="${GKE_MACHINE_TYPE}" \
    --node-version="${GKE_CLUSTER_VER}" \
    --num-nodes="${GKE_NUM_NODES}" \
    --preemptible \
    --region="${GCP_REGION}" \
    --release-channel="${GKE_RELEASE}"
}

#FIXME add status check on cluster to determine when it's ready to do X or be deleted
#gke_check_status(){
#  gcloud container clusters list \
#    --filter "name = ${GKE_CLUSTER_NAME} AND status = running"
#}

gke_delete(){
  gcloud container clusters delete "${GKE_CLUSTER_NAME}" \
    --async \
    --region="${GCP_REGION}"
}
