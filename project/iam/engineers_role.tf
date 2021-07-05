module "project_engineers_role" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 6.2"

  target_level = "project"
  target_id    = var.project_id
  role_id      = "projectEngineers"
  title        = "projectEngineers"
  description  = "Custom role for Project Engineers"
  members      = local.project_engineers_to_iam
  permissions = [
    "bigquery.jobs.listAll",
    "bigquery.tables.get",
    "bigquery.tables.getData",
    "bigquery.tables.list",
    "cloudbuild.builds.create",
    "cloudbuild.builds.update",
    "container.pods.delete",
    "container.pods.exec",
    "errorreporting.groupMetadata.update",
    "iap.tunnelInstances.accessViaIAP",
    "pubsub.subscriptions.consume",
    "secretmanager.versions.add",
    "serviceusage.services.use"
  ]
}
