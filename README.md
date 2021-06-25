##########################################
# GCP PROJECT NOTES                      #
##########################################

# Useful notes:

GCP Projects
cubicbi-dev01  & cubicbi (prod)


Project structure
Tf code is based on project name suffix to be 3 chars - ie dev or prd - e.g. cubicbi-dev 

# GIT

NOTE: Windows Credential mamager was storing work user name and trying to git push with those credentials (and failing) - found this:

Start --> Control Panel ---> User Accounts ---> Manager your credentials ---> Windows Credentials

Then search for an entry like, git:https://github.com and remove it. It works fine after that.

---> Cloud Source Repositories
Use this to configure the Git repo(s) available to the project.

REPO: https://github.com/neilaathey/terraform-build

# PYTHON 


# TERRAFORM SETUP
- set backend tf state file using backend.tf config file (in each tf folder)
    bucket = "cubicbi-dev01-tf-state"      
    prefix = "project/build-triggers"
    

# IAM

# CLOUD STORAGE - BUCKETS etc

# CLOUD BUILD TRIGGERS

Setup: originally created first trigger manually: TestTrigger01 - watches 

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
