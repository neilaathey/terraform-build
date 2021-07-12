locals {
  common_apis = yamldecode(file("${path.cwd}/common-apis.yaml"))
  enabled_apis = distinct(
    concat(
      lookup(local.common_apis, "enabled_apis", []),
      lookup(local.project_config, "enabled_apis", [])
    )
  )
}
resource "google_project_service" "project_api" {
  for_each           = toset(local.enabled_apis)
  disable_on_destroy = false
  project            = var.project_id
  service            = each.key
}
