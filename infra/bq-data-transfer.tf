output "test_output" {
  value = "Hello Neil!"  
}

# data "google_project" "project" {
#   project_id = "cubicbi-dev01"
# }
# resource "google_project_iam_member" "permissions" {
#   role   = "roles/iam.serviceAccountShortTermTokenMinter"
#   member = "serviceAccount:service-${data.google_project.project.number}@test-terraform.iam.gserviceaccount.com"
# }
resource "google_bigquery_dataset" "useful_backup" {
  #depends_on = [google_project_iam_member.permissions]
  project       = var.project_id
  dataset_id    = "useful_backup"
  friendly_name = "foo"
  description   = "bar"
  location      = "EU"
}

resource "google_bigquery_data_transfer_config" "test-data-transfer" {
  data_source_id         = "cross_region_copy"    # this works with this irrelevant value...!?!
  destination_dataset_id = "useful_backup" #google_bigquery_dataset.useful_backup.dataset_id
  display_name           = "test_copy_dataset_config_display_name"
  location               = "EU"
  #service_account_name   = "cubicbi-dev01-serviceaccount@cubicbi-dev01.iam.gserviceaccount.com"
  params = {
    overwrite_destination_table = "true"
    source_dataset_id           = "useful"   
  }
  project                = var.project_id
  schedule               = "every mon, tue, wed, thu, fri 02:00"
  
}

