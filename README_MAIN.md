##########################################
# GCP PROJECT NOTES                      #
##########################################

# Useful notes:

GCP Projects

gcloud auth application-default login

Project structure
Tf code is based on project name suffix to be 3 chars - ie dev or prd - e.g. <project-name> 

# APIs
Enable:
BigQuery
BigQuery data transfer service
Cloud Functions


# DOCKER
Local Dockerfile can be built by selecting different base image ie. 
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim
-this should be deployed to GCP to use cached version
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim_cloudbuild_cache

-When building locally I had to clear Docker cache and also reboot - due to docker build errors:
docker buillder prune


# TERRAGRUNT DOCKER IMAGE
- Check the folder 'step-terragrunt' and contents into Git
- Set up cloud build trigger (manually? yes on dev) - point to project\build-steps\step-terragrunt\cloudbuild.yaml 
- Run the build (manually?) and set trigger to 'Disabled' - so it does not run each time something changes
- This creates the Docker image and stores in the GCP Container Registry - gcr.io
- 'entrypoint.bash' controls the execution steps ie plan, apply (with auto-approve) etc  plus post_plan.py execution
        either add execution perms to Dockerfile; RUN chmod +x /builder/entrypoint.bash           #had to add this
        or, check into git with; git add --chmod=+x -- afile

- Upgrading Terraform & Terragrunt versions:
    - change versions in cloudbuild.yaml
    - redeploy and rebuild using terragrunt-trigger - note the images are stored in a different project (although a trigger does exist on barb-files-dev)
    - 
    - to te


# GIT

NOTE: Windows Credential mamager was storing work user name and trying to git push with those credentials (and failing) - found this:

Start --> Control Panel ---> User Accounts ---> Manager your credentials ---> Windows Credentials

Then search for an entry like, git:https://github.com and remove it. It works fine after that.

---> Cloud Source Repositories
Use this to configure the Git repo(s) available to the project.

REPO: https://github.com/neilaathey/terraform-build

Note: Select the latest Github app: Cloud Build GitHub App  (not the legacy one - which is not compatible with common/trigger module))

# PYTHON 
- use .venv for each cloud function folder to keep each isolated


# TERRAFORM SETUP
- set backend tf state file using backend.tf config file (in each tf folder)
    bucket = "tf-state-<project-name>"      
    prefix = "project/build-triggers"
    

# IAM
Cloudbuild service needs:
    BigQuery Resource Admin (check this level = looks like role/owner is being granted to the CloudBuild service)

- Set project numbers in common-settings.yaml
- Set replacement variables in project-<projet-name>-yaml - NOTE: this is treated as a template file so comments are also replaced and vars need to exist
- Create custom roles in project-<projet-name>-yaml
- Set permissions in project-<projet-name>-yaml
- main.tf ---->  two main resources :  "google_project_iam_custom_role"  and "project_iam_bindings"   
    - loops through all roles and permissions for each 
- engineers_role.tf -----> uses "google_project_iam_custom_role" - adding all required perms for each included email address in core-engineers.yaml


# CLOUD STORAGE - BUCKETS etc

# CLOUD BUILD TRIGGERS

Setup: originally created first trigger manually: TestTrigger01 - watches 
Docker image deployed via Github then built manually using build trigger


# INFRA - BigQuery resources: table, view, stored proc, scheduled query, data transfer service

    objective: deploy all bq resource types using terraform



# CLOUD FUNCTIONS

    objective:  write a simple cloud function and deploy to GCP using git trigger/terraform

# PUB SUB




ORDER OF DEPLOYMENT

Project pre-deployment setup:
- manually create 'project' trigger to watch triggers in Git repo sub folder 'project'

For each GCP service:

- create trigger terraform config and check into repo
- 

- Check changes into Git
- trigger fires and runs CloudBuild.yaml
- terraform [plan/apply] in build directory
