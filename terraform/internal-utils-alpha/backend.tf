terraform {
  backend "gcs" {
    bucket = "internal-cluster-bucket-tfstate-462c9fe5f358165b"
    prefix = "terraform/state"
  }
}
