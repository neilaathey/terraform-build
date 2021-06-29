# [Terragrunt](https://github.com/gruntwork-io/terragrunt) cloud builder

## Terragrunt cloud builder
This builder can be used to run the terragrunt tool in the GCE. Terragrunt [product page](https://github.com/gruntwork-io/terragrunt) is a wrapper for Terraform [product page](https://www.terraform.io/):

## Using this builder
plan:  
```
steps:
- id: 'tf plan'
  name: 'gcr.io/barb-files-dev/terragrunt'
  dir: '$_DIR'
  args:
  - 'plan'
  env:
  - 'PULL_REQUEST_ID=$_PR_NUMBER'
  - 'BRANCH=$BRANCH_NAME'
  - 'REPO_NAME=$REPO_NAME'
```
  
apply:  
```
steps:
- id: 'tf apply'
  name: 'gcr.io/barb-files-dev/terragrunt'
  dir: '$_DIR'
  args:
  - 'apply'
```
  
destroy:  
```
steps:
- id: 'tf apply'
  name: 'gcr.io/barb-files-dev/terragrunt'
  dir: '$_DIR'
  args:
  - 'destroy'
```

### Terragrunt backend

Terragrunt builder is based on Terraform builder [link](https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/terraform). Most of the details about backend are the same as for terraform. Please check examples for the differences and example configuration [link](examples/gcs_backend/README.markdown)
