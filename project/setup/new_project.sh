#!/bin/bash

set -e

PROJECT_ID=$1

gcloud projects create "${PROJECT_ID}" --organization=636977878793 || exit 1

gcloud beta billing projects link "${PROJECT_ID}" --billing-account=0112C2-69639A-12B684 || exit 1

echo "Run project/setup/setup_project_part1.sh followed by project/setup/setup_project_part2.sh to finish project initialisation"
