# Project Setup

Scripts to enable APIs and submit builds to bootstrap a new project.

The enable API script should be run first, followed by some manual owner/admin level actions detailed [here](https://docs.google.com/document/d/1dlwUDv-KE_A8AYhSQylbgR8Y6AYFRihY0VUD55f1MfU/edit?usp=sharing),

Run the scripts from the root of the cato-bi-barb-files repo, like this:

```
~/cato-bi-barb-files$ project/setup/new_project.sh <project>

~/cato-bi-barb-files$ project/setup/setup_project_part1.sh <project>
~/cato-bi-barb-files$ project/setup/setup_project_part2.sh <project>
```

Check for any errors before running the next script

Note `new_project.sh` requires admin level for the billing account.
`setup_project_part1.sh` and `setup_project_part2.sh` require owner level
permissions to the GCP project.
