variable "credentials_file" {}

variable "project_id" {}

variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

#variable "gcp_service_list" {
#  description ="The list of apis necessary for the project"
#  type = list(string)
#  default = [
#    "admin.googleapis.com",
#    "cloudapis.googleapis.com",
#    "cloudbilling.googleapis.com",
#    "compute.googleapis.com",
#    "container.googleapis.com",
#    "containerregistry.googleapis.com",
#    "iam.googleapis.com",
#    "iamcredentials.googleapis.com",
#    "logging.googleapis.com",
#    "monitoring.googleapis.com",
#    "networkmanagement.googleapis.com",
#    "storage.googleapis.com"
#  ]
#}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
