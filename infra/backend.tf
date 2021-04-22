terraform {
  backend "gcs" {
    bucket = "cubicbi-dev01-tf-state"
    prefix = "terraform/state/app"
  }
}
