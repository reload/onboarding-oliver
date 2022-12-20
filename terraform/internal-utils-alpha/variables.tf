variable "credentials_file" {}

variable "project_id" {}

variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
