# Temp Infrastructure

This is useful for when we occasionally having requests that involve temporary
resources (temp tables, buckets for transfers)

For each resource, please stick a comment to indicate what it's for and
how long it should be there for just to make it easier to track.

e.g. `barb-files-dev/some-random-bucket.tf`

A Trello card link can also be useful.

```tf
# Random bucket for adhock upload. Will be required until 10th September 2020

module "random_bucket" {
  source          = "../../../../common/terraform/modules/gcp_gcs_bucket"
  project_id      = var.project_id
  name            = "random-bucket-${var.project_id}"
  location        = "europe-west1"
  storage_class   = "STANDARD"
}

```

# Common Use Cases

## Backup Dataset 

Create a file and paste the following

```
module "<DATASET>_backup_dataset" {
  source                     = "../../../../common/terraform/modules/gcp_bigquery"
  project_id                 = var.project_id
  dataset_id                 = "<DATASET>_<YYYYMMDD>"
  delete_contents_on_destroy = true
}

resource "google_bigquery_data_transfer_config" "<DATASET>_backup_config" {
  project                = var.project_id
  display_name           = "<DATASET>-backup"
  location               = "EU"
  data_source_id         = "cross_region_copy"
  destination_dataset_id = module.<DATASET>_backup_dataset.dataset_name
  params = {
    source_dataset_id           = "<DATASET>"
    source_project_id           = var.project_id
    overwrite_destination_table = false
  }
}

```

Replace the following instances:

- `<DATASET>` the name of the dataset you wish to backup
- `<YYYMMDD>` the hardcoded date of the backup. This will be appended to the backup
  dataset name

## Run Bigquery DML Query

To run either an `INSERT/UPDATE/DELETE/MERGE` statement, you can use the following
job template for doing this.

Please note, you'll need to check the result of the job via the GCP console
as this only deploys the job, it does not perform strict validation of the
query. You should be able to see it in "Query history" -> "Project history"

```
resource "google_bigquery_job" "<JOB_ID>_<YYYYMMDD>" {
  job_id   = "<JOB_ID>_<YYYYMMDD>"
  location = "EU"
  project  = var.project_id

  lifecycle { ignore_changes = [query] }

  query {
    create_disposition = ""
    write_disposition  = ""
    use_legacy_sql     = false
    query              = <<-EOF
      <SQL_STATEMENT>
    EOF
  }
}
```

Replace the following instances:

- `<JOB_ID>` - Just a random string which can be used to uniquely identify the job
- `<YYYYMMDD>` - Hard coded date of the BQ job (just incase there's a clash in future)
- `<SQL_STATEMENT>` - Your SQL Statment to run (e.g. `INSERT/UPDATE/DELETE`)

## Running Bash Commands

If you want to run a one off bash command. (e.g. `gcloud`, `gsutil`, `bq`), You can
create a file like this:

```
locals {
  bash_command = <<-EOF
    <BASH_COMMAND>
  EOF
}

resource "null_resource" "<COMMAND_NAME>" {

  triggers = {
    shell_hash = "${sha256(local.bash_command)}"
  }
  provisioner "local-exec" {
    command     = local.bash_command
    interpreter = ["sh", "-c"]
  }
}
```

Replace the following instances:

- `<BASH_COMMAND>`: the bash command. e.g. `echo "hello world"`
- `<COMMAND_NAME>`: sensible name
