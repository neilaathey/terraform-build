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
sourcerepo.googleapis.com
IAM

# SCRIPTED PROJECT SET UP
-Use WSL (instead of Git Bash which is limited - see following gitbash notes)
<!-- -Use Git bash in VSC to run commands:  
    Open the command palette using Ctrl + Shift + P.
    Type - Select Default Profile
    Select Git Bash from the options
    Click on the + icon in the terminal window
    The new terminal now will be a Git Bash terminal. Give it a few seconds to load Git Bash
    You can now toggle between the different terminals as well from the dropdown in terminal. -->

1. Create new project either manually or by running bash: $<repo root>$ project/setup/new_project.sh <new project name>
    -NOTE: /r errros etc indicate incompatible CRLF-LF setting on the bash file - open and save it with 'LF' (bottom right of VSC window)
2. Enable billing - this should be set by new_project.sh but if errors can be done manually once new project is created.
    NOTE: this seems to require admin perms so restarted VSC as admin then run this:
        gcloud beta billing projects link "<new project name>" --billing-account=<billing acccount number>
        note: only 3 projects allowed per billing acct as standard - request more through contacting Google. 
3. Run:  root$ project/setup/setup_project_part1.sh <project>
    This should enable all APIs required - if not run _enable_apis.sh

NOTE: The setup script isn't programmed to work with Git Bash (echo $OSTYPE=msys ) - so best use Windows Subsystem For Linux WSL2

In WSL:
 - make sure the bash file CRLF-LF type to be run is set to 'LF'  (CRLF causes errors)
 - https://code.visualstudio.com/docs/remote/troubleshooting#_resolving-git-line-ending-issues-in-containers-resulting-in-many-modified-files
 - install WSL VSC extension and configure.  
 - open WSL and cd to project root.  Type . code to open (administrator) VSC WSL session - open Terminal, if not already open.
 - install python3:
    python3 --version       #to check if installed already
    sudo apt update && upgrade
    sudo apt install python3 python3-pip ipython3

-follow instructions output from part1.sh:
3.1 Follow steps to enable CloudBuild API and connect Git repo: https://cloud.google.com/cloud-build/docs/automating-builds/create-github-app-triggers
3.2 Add new project name to:  project/iam/common-settings.yaml
3.3 Visit https://console.cloud.google.com/monitoring/settings/usage?authuser=0&project=<new project name> to initialise StackDriver monitoring workspace
3.4 Commit new files and changes into Git (I used Windows VSC version for this to save setting up Gitbash in WSL)

4. Set account config to active logged-in account: gcloud config set account neil@cubic-bi.com
4.1 Set project: gcloud config set project cubicbi-tst
5. Add new project number to:  project/iam/common-settings.yaml
6. Manually connect Github repo to the new project: https://cloud.google.com/cloud-build/docs/automating-builds/create-github-app-triggers


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
    - to test - set the terragrunt image reference in cloudbuild.yaml to the dev docker image 
        ie   name: 'gcr.io/bi-builds-prd/terragrunt' to   name: 'gcr.io/bi-builds-dev/terragrunt'



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
