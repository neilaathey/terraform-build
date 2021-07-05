terraform {
  backend "gcs" {
    bucket = "cubicbi-dev-tf-state"
    prefix = "project/iam"
  }
}

locals {
  env                        = substr(var.project_id, -3, -1)
  project_engineers_baserole = local.env == "prd" ? "roles/viewer" : "roles/editor"
  project_engineers_to_iam   = yamldecode(file("${path.cwd}/core-engineers.yaml"))

  common_settings     = yamldecode(file("${path.cwd}/common-settings.yaml"))
  project_numbers_dev = lookup(local.common_settings, "project_numbers_dev", {})
  project_numbers_prd = lookup(local.common_settings, "project_numbers_prd", {})
  project_numbers_all = merge(local.project_numbers_dev, local.project_numbers_prd)
  project_settings = yamldecode(
    templatefile(
      "project-${var.project_id}.yaml",
      {
        project_number     = local.project_numbers_all,
        project_number_dev = local.project_numbers_dev,
        #project_number_prd = local.project_numbers_prd,
        current_project_id = var.project_id
      }
    )
  )
  custom_roles = merge(lookup(local.common_settings, "custom_roles", {}), lookup(local.project_settings, "custom_roles", {}))

  project_permissions               = local.project_settings["permissions"]
  project_engineers_baserole_merged = concat(local.project_engineers_to_iam, lookup(local.project_permissions, local.project_engineers_baserole, []))
  security_reviewer_merged          = concat(local.project_engineers_to_iam, lookup(local.project_permissions, "roles/iam.securityReviewer", []))
}

resource "google_project_iam_custom_role" "project_roles" {
  for_each    = local.custom_roles
  project     = var.project_id
  role_id     = each.value["role_id"]
  title       = each.value["title"]
  description = each.value["description"]
  permissions = each.value["permissions"]
}

module "project_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.2"
  mode    = "additive"

  projects = [var.project_id]

  bindings = merge(
    local.project_permissions,
    {
      (local.project_engineers_baserole) = local.project_engineers_baserole_merged
      "roles/iam.securityReviewer"       = local.security_reviewer_merged
    },
  )

  depends_on = [google_project_iam_custom_role.project_roles]
}

variable "project_id" {
  type        = string
  default     = "cubicbi-dev"
  description = "Project ID to deploy resources in."
}
