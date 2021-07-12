terraform {
  backend "gcs" {
    prefix = "project/infra/secrets"
  }
}

variable "project_id" {
  type        = string
  description = "Project ID to deploy resources in."
}

locals {
  project_config = fileexists("project-${var.project_id}.yaml") ? yamldecode(file("project-${var.project_id}.yaml")) : {}
}

module "common_secret" {
  for_each              = try(local.project_config["secrets"], {})
  source                = "../../../common/terraform/modules/gcp_secret_manager"
  project_id            = var.project_id
  name                  = each.key
  secret_access_members = lookup(each.value, "accessors", null)
}
