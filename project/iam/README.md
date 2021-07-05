# Project IAM

This Terraform deployment controls access to roles as well as creating custom
roles.

For common roles that can be applied to all projects, you should add an entry
to `common-settings.yaml`. Otherwise, for project specific entries, add to
the appropriate `project-<GCP_PROJECT>.yaml`.

There is a `projectEngineers` custom role which will be added to each project.
This role will provide standard access accross all projects. You can see the
permissions applied by taking a look at `engineers_role.tf`. Core engineers
who will be maintaining this project should be added to this.

The same users will also acquire the `roles/viewer` role for projects that end
in `-prd`. Any other ending, the users will acquire `roles/editor`.
