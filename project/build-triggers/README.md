# Module to manage Cloud Build triggers

Common, global triggers applied across all projects should be put inside `common-triggers.yaml`
Project-specific ones should be in `project-${PROJECT_ID}.yaml` - we can also overwrite common ones with project-specific values by putting them there.

There are 3 types of triggers (defined in `type` property):
- `terraform` - by default, automatically creates -apply and also on prd projects, -plan triggers
- `app_push_trigger` - typical trigger, using GitHub App connection
- `pr_trigger` - trigger executed on Pull Request, using GitHub App

The `cloudbuild.yaml` config in this directory is responsible for creating the triggers themselves in Google Cloud.

Example usage in yaml file:

```
  trigger1:
    type: terraform
    cloudbuild_path: folder1/cloudbuild.yaml
    included_files:
      - folder1/file1
      - folder2/**
    substitutions:
      _TEST_KEY_: test-value
    extra_attributes:
      enable_tf_plan: false    # enable plan on dev or disable plan on prd
      disabled: true           # disable trigger on prd projects

  trigger2:
    type: app_push_trigger
    cloudbuild_path: folder2/cloudbuild.yaml
    included_files: []
    substitutions: {}
    extra_attributes: {}
```
