terraform {
  backend "gcs" {
    bucket = "cubicbi-dev-tf-state"
    prefix = "terraform/state/app"
  }
}
