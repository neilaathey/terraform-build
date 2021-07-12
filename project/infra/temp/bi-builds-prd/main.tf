terraform {
  backend "gcs" {
    prefix = "project/temp-infra"
  }
}

variable "project_id" {
  type        = string
  description = "Project ID to deploy resources in."
}
