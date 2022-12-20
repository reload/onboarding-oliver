terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.44.1"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

# Terraform plugin for creating random IDs
resource "random_id" "instance_id" {
  byte_length = 8
}

# Storage bucket
resource "google_storage_bucket" "default" {
  name          = "internal-cluster-bucket-tfstate-${random_id.instance_id.hex}"
  force_destroy = false
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Static External IP
module "address" {
  source       = "terraform-google-modules/address/google"
  version      = "~> 3.1"
  project_id   = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  names = [
    "internal-utils-loadbalancer-ip"
  ]
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name                     = "${var.project_id}-cluster"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  maintenance_policy {
    daily_maintenance_window {
      start_time = "00:00"
    }
  }
}

# Node pool for GKE cluster
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.project_id}-cluster-nodes"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"

  }
}
