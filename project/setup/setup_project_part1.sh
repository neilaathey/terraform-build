#!/bin/bash
if [[ $# -ne 1 ]] ; then
    echo "Usage - run from repo root: project/setup/setup_project_part1.sh <project>"
    exit 1
fi

PROJECT_ID=$1

if [[ ! ( "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ) ]]; then
  echo "\"$OSTYPE\" is not supported"
  exit 1
fi

bash project/setup/_enable_apis.sh "${PROJECT_ID}"


PROJECT_NUMBER=$(gcloud projects describe "${PROJECT_ID}" --format="value(projectNumber)")

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role roles/owner


gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${PROJECT_NUMBER}@cloudservices.gserviceaccount.com" \
  --role roles/owner

echo "Your new project has been created - ${PROJECT_ID}"
echo "Follow steps to link to GitHub - https://cloud.google.com/cloud-build/docs/automating-builds/create-github-app-triggers"
echo ""

echo "Add ${PROJECT_ID}: '${PROJECT_NUMBER}' to project/iam/common-settings.yaml"
echo ""

###### Commented out until IAM PR merged
echo "Creating copy of iam/project-template.yaml for the new project and updating it with project's names"
cp project/iam/project-template.yaml "project/iam/project-${PROJECT_ID}.yaml"

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i "" "s/PROJECT_NAME/${PROJECT_ID}/g" "project/iam/project-${PROJECT_ID}.yaml"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sed -i "s/PROJECT_NAME/${PROJECT_ID}/g" "project/iam/project-${PROJECT_ID}.yaml"
fi
echo ""

echo "Creating empty triggers file for project"
echo "triggers:" > "project/build-triggers/project-${PROJECT_ID}.yaml"
echo ""

echo "Creating empty meta config for project"
cp project/project-meta/project-template.yaml "project/project-meta/project-${PROJECT_ID}.yaml"

echo "Initialising temp infra for project"
mkdir "project/infra/temp/${PROJECT_ID}"; cp project/infra/temp/template.tf "project/infra/temp/${PROJECT_ID}/main.tf"
echo ""

echo "Visit https://console.cloud.google.com/monitoring/settings/usage?authuser=0&project=${PROJECT_ID} to initialise StackDriver monitoring workspace"

echo "Commit above changes"

echo "Once done, run project/setup/setup_project_part2.sh to finish project initialisation"
