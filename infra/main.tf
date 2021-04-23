output "test_output" {
  value = "Hello Neil!"  
}

variable "project_id" {
  type        = string
  default     = "cubicbi-dev01"
  description = "Project ID to deploy resources in."
}

resource "google_bigquery_dataset" "useful_backup" {
  #depends_on = [google_project_iam_member.permissions]
  project       = var.project_id
  dataset_id    = "useful_backup"
  friendly_name = "foo"
  description   = "bar"
  location      = "EU"
}

# resource "google_bigquery_data_transfer_config" "test_copy_dataset_config" {
#   project                = var.project_id
#   display_name           = "test_copy_dataset_config_display_name"
#   location               = "EU"
#   schedule               = "first sunday of quarter 00:00"
#   data_source_id         = "scheduled_query"
#   destination_dataset_id = google_bigquery_dataset.useful_backup.dataset_id
#   service_account_name   = "test-terraform"
#   params = {
#     source_dataset_id           = "useful"
#     source_project_id           = var.project_id
#     write_disposition           = "WRITE_TRUNCATE"

#   }
# }

resource "google_bigquery_data_transfer_config" "test_copy_dataset_config" {
  project                = var.project_id
  display_name           = "test_copy_dataset_config_display_name"
  location               = "EU"
  schedule               = "every mon, tue, wed, thu, fri 02:00"
  data_source_id         = "useful"
  destination_dataset_id = google_bigquery_dataset.useful_backup.dataset_id
  params = {
    overwrite_destination_table = "true"
    source_dataset_id           = "useful"
  }
}

#terraform import google_bigquery_data_transfer_config.default test_copy_dataset_config