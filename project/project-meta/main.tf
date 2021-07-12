terraform {
  backend "gcs" {
    prefix = "project/meta"
  }
}

locals {
  project_config  = yamldecode(templatefile("${path.cwd}/project-${var.project_id}.yaml", { project_id = var.project_id }))
  env             = lookup(local.project_config, "env", substr(var.project_id, -3, -1))
  common_settings = yamldecode(templatefile("${path.cwd}/common-${local.env}.yaml", { project_id = var.project_id }))
  secret_project_id = lookup(local.project_config, "secret_project_id",
    lookup(
      local.common_settings,
      "secret_project_id",
      var.project_id
    )
  )
}

variable "project_id" {
  type        = string
  description = "Project ID to deploy resources in."
}
