# Universe: Infra

Notes - on settig up a new bq table/resource

## Step By Step Guide

### 00 Preperation

1. Log in to GCP using cli: gcloud auth application-default login
1. Create branch from 'master' or select current working branch in VCS

### 01: Get schema from BigQuery

1. Change working dir to schema folder: e.g.  `cd .\universe\infra\schemas\barb_universe\tables\`
1. Run this in console:

        bq show --schema --format=prettyjson barb_universe.Universe_HeaderFooter > Universe_HeaderFooter.json
        bq show --schema --format=prettyjson barb_universe.Universe_Raw > Universe_Raw_schema.json
        bq show --schema --format=prettyjson barb_universe.Universe_Raw_HeaderFooter > Universe_Raw_HeaderFooter.json

1. In resulting file, open and change encoding to UTF-8 in bottom VSC status bar - select save with encoding- note: reload file after change to correct display


### 02 Add schema definition to terraform definition file

1. In cato-bi-barb-files\universe\infra\bigquery.tf add config to object-type section ie tables, views, procedures etc. (find a similar resource config to copy if already exists)

Examples:

- Non partitioned example:

        Universe_HeaderFooter = {
            schema                      = file("schemas/barb_universe/tables/Universe_HeaderFooter.json")
            require_partition_filter    = false
            time_partitioning           = false
        }

- Partitioned table by Integer Range:

        Universe_Raw = {
            schema                      = file("schemas/barb_universe/tables/Universe_Raw.json")
            require_partition_filter    = false
            range_partitioning          = true
            range_partitioning_field    = "YearMonth"
            range_partitioning_start    = "201001"
            range_partitioning_end      = "203712"
            range_partitioning_interval = 1
            time_partitioning           = false
            clustering                  = "Reporting_Panel_code,Effective_from_date,Effective_to_date"
        }

### 03 Local Development

1. Change working dir to terraform dir: `cd \\cato-bi-barb-files\universe\infra\`
1. Run this: `terraform init -lock=false -backend-config=bucket=tfstate-barb-files-dev` - this will then use the remote state file

1. Create override.tf file in `\\cato-bi-barb-files\universe\infra\override.tf` with the following contents:

        terraform {
            backend "local" {
            }
        }

    This is to force a local state file in order to compare changes and not to interfere with remote state.
1. In the console, run:  `terraform init`. It should prompt you to copy the remote tfstate file locally. Say Yes. Should see a green message output - containing 'Successfully configured the backend "local"! Terraform will automatically' and 'Terraform has been successfully initialized!'

### 04 Import Existing Resources (Only required if GCP resources already exists)

For resources that already exist, they will need to be imported into Terraform's state file. The CloudBuild Terragrunt image will automatically look for an executable file relative to the tf directory `tmp/import-<PROJECT_ID>.sh`.

There's a script which will help generate imports for the typical GCP resource located `cato-bi-barb-files\common\terraform\modules\generate_import.py`. e.g. Usage:

```
python3 common\terraform\modules\generate_import.py  --project barb-files-dev --path "universe\infra"
```

Otherwise, you can create this file manually and add each import command manually. Each resource import syntax can be found on the [Terraform Google Provider Resource Page](https://registry.terraform.io/providers/hashicorp/google/latest/docs). Note in a lot of cases, we will be using our own modules, so you'll need to embed the module into the name of the import command.

e.g. for a Bigquery table, the syntax is 

```sh
terraform import -var=project_id=barb-files-dev google_bigquery_table.tf_name project/dataset/table`
```

would be something like

```sh
terraform import -var=project_id=barb-files-dev 'module.tf_dataset.module.tables.google_bigquery_table.table[\"tf_name\"]' 'barb-files-dev/dataset/table'
```
Examples:

```
terraform import -var=project_id=barb-files-dev 'module.dataset_barb_universe.module.tables.google_bigquery_table.table[\"Universe_HeaderFooter\"]' 'barb-files-dev/barb_universe/Universe_HeaderFooter'

terraform import -var=project_id=barb-files-dev 'module.dataset_barb_universe.module.tables.google_bigquery_table.table[\"Universe_Raw\"]' 'barb-files-dev/barb_universe/Universe_Raw'
```

**Note Use escape chars for double quotes - when running in powershell**

### 05 Comparing/Testing

1. Run `terraform plan` to check what your changes would do
    This should show the plan for the new resource - check this in detail for any destroy messages - there should be **NONE**

    - if any destroy changes then amend bigquery.tf definition to allign with existing object
        for instance, partitioning may be wrong - any destroy messages could delete existing data

    - note: initial error message relating to terraform version needing to be upgraded - downloaded and installed v0.14.7
   
   Find the config for the new resource(s) being added - check it does what is required with no extra attributes/properties that could cause data loss


** NOTE: do not run `terraform apply` locally - this is done by the cloud build - also if not applied then another plan test can be carried out - see Step 10...**

### 06 - Check In Code / Test Cloudbuild

1. Check in changes to Git - by adding individual files only 

        git add bigquery.tf
        git add .\schemas\barb_universe\tables\Universe_Raw.json
        git add .\tmp\import-barb-files-dev.sh
        git commit -m 'message'
        git push

1. In GCP - Cloud Build - test run trigger manually e.g. 'universe-infra-apply-barb-files-dev' 
    - change branch to the one being tested e.g. 'universe-initial-infra-neils'
    - set variable parameter value to 'plan' - to test and check over terraform script.

1. Once happy with terraform script - rerun trigger using 'apply' as value param.
1. Create a Pull Request