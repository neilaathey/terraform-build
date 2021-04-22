output "test_output" {
  value = "Hello Neil!"  
}

variable "project_id" {
  type        = string
  default     = "cubicbi-dev01"
  description = "Project ID to deploy resources in."
}

resource "google_bigquery_data_transfer_config" "test_copy_dataset_config" {
  project                = var.project_id
  display_name           = "test_copy_dataset_config"
  location               = "EU"
  schedule               = "every mon, tue, wed, thu, fri 02:00"
  data_source_id         = "useful"
  destination_dataset_id = "useful_backup"
  params = {
    source_dataset_id           = "useful"
    source_project_id           = var.project_id
    overwrite_destination_table = true
  }
}
