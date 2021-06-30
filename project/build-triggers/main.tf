terraform {
  required_version = ">= 0.12.6"
  required_providers {
    google      = ">= 3.1"
    google-beta = ">= 3.1"
  }
  backend "gcs" {
    bucket = "cubicbi-dev-tf-state"      
    prefix = "project/build-triggers"
  }
}


locals {
  common_settings = yamldecode(
    templatefile(
      "${path.cwd}/common-triggers.yaml",
      {
        project_id = var.project_id
      }
    )
  )
  project_settings = yamldecode(
    templatefile(
      "${path.cwd}/project-${var.project_id}.yaml",
      {
        project_id = var.project_id
      }
    )
  )
  env                 = lookup(local.project_settings, "env", substr(var.project_id, -3, -3))
  common_env_settings = yamldecode(templatefile("${path.cwd}/common-${local.env}.yaml", { project_id = var.project_id }))
  repo_root_dir       = "${path.cwd}/../.."
  repo_org            = ""
  repo_name           = "terraform-build"
}

variable "project_id" {
  type          = string
  description   = "Project ID to deploy resources in."
  default       = "cubicbi-dev"
}
