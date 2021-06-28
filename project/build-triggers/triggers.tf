locals {
  disable_triggers    = local.env == "prd" ? false : true
  enable_tf_plan      = local.env == "prd" ? true : false
  branch_regex        = local.env == "prd" ? "^master$" : ".*"
  common_triggers     = lookup(local.common_settings, "triggers", {})
  common_env_triggers = lookup(local.common_env_settings, "triggers", {})
  project_triggers    = try(local.project_settings["triggers"], {})
  triggers            = merge(local.common_triggers, local.common_env_triggers, local.project_triggers)
}

resource "google_cloudbuild_trigger" "terraform_plan" {
  for_each       = { for k, v in local.triggers : k => v if v["type"] == "terraform" && lookup(v.extra_attributes, "enable_tf_plan", local.enable_tf_plan) }
  provider       = google-beta
  project        = var.project_id
  name           = "${each.key}-plan-${var.project_id}"
  description    = "${each.key}-plan-${var.project_id}"
  disabled       = false
  filename       = each.value["cloudbuild_path"]
  included_files = each.value["included_files"]
  substitutions = merge(
    {
      _TF_ACTION = "plan"
    },
    each.value["substitutions"]
  )

  github {
    owner = local.repo_org
    name  = local.repo_name
    pull_request {
      branch          = "^master$"
      comment_control = lookup(each.value.extra_attributes, "require_comment", null)
    }
  }
}

resource "google_cloudbuild_trigger" "terraform_apply" {
  for_each       = { for k, v in local.triggers : k => v if v["type"] == "terraform" }
  provider       = google-beta
  project        = var.project_id
  name           = "${each.key}-apply-${var.project_id}"
  description    = "${each.key}-apply-${var.project_id}"
  disabled       = lookup(each.value.extra_attributes, "disabled", local.disable_triggers)
  filename       = each.value["cloudbuild_path"]
  included_files = each.value["included_files"]
  substitutions = merge(
    {
      _TF_ACTION = "apply"
    },
    each.value["substitutions"]
  )

  github {
    owner = local.repo_org
    name  = local.repo_name
    push {
      branch = lookup(each.value, "branch_regex", local.branch_regex)
    }
  }
}

resource "google_cloudbuild_trigger" "trigger" {
  for_each       = { for k, v in local.triggers : k => v if v["type"] != "terraform" }
  provider       = google-beta
  project        = var.project_id
  name           = each.key
  description    = each.key
  disabled       = lookup(each.value.extra_attributes, "disabled", local.disable_triggers)
  filename       = each.value["cloudbuild_path"]
  included_files = each.value["included_files"]
  substitutions  = lookup(each.value, "substitutions", {})

  dynamic "github" {
    for_each = each.value["type"] == "pr_trigger" ? [1] : []
    content {
      owner = local.repo_org
      name  = local.repo_name
      pull_request {
        branch          = "^master$"
        comment_control = lookup(each.value.extra_attributes, "require_comment", null)
      }
    }
  }

  dynamic "github" {
    for_each = each.value["type"] == "app_push_trigger" ? [1] : []
    content {
      owner = local.repo_org
      name  = local.repo_name
      push {
        branch = lookup(each.value, "branch_regex", local.branch_regex)
      }
    }
  }
}


variable "triggers" {
  description = "List of triggers to deploy (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    type             = string
    cloudbuild_path  = string
    included_files   = list(string)
    substitutions    = map(string)
    extra_attributes = map(string)
  }))
}
