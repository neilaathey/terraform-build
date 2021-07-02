terraform {
  backend "gcs" {
    prefix = "universe/infra"
    bucket = "cubicbi-dev-tf-state"
  }
}

variable "project_id" {
  type        = string
  description = "Project ID to deploy resources in."
  default = "cubicbi-dev"
}



# module "dataset_barb_universe_staging" {
#   source       = "../common/terraform/modules/gcp_bigquery"
#   project_id   = var.project_id
#   dataset_id   = "barb_universe_staging"
#   dataset_name = "barb_universe_staging"
#   description  = "BARB Universe tables - staging"

#   dataset_labels = {
#     business_area = "air_time_sales"
#     data_domain   = "barb"
#   }

#     data_owners = [
#     "user:neil.athey@itv.com"
#   ]
  
# }
