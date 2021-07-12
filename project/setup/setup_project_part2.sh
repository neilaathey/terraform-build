#!/bin/bash

if [[ $# -ne 1 ]] ; then
    echo "Usage - run from repo root: project/setup/setup_project_part2.sh <project>"
    exit 1
fi

PROJECT=$1

BUILD="gcloud --project=${PROJECT} builds submit . --config "

echo "################################# build 1"
$BUILD project/terraform/cloudbuild.yaml

echo "################################# build 2"
$BUILD project/build-triggers/cloudbuild.yaml --substitutions="BRANCH_NAME=master"

sleep 5

echo "################################# trigger run"
TRIGGER_RUN="gcloud beta builds triggers run --project=${PROJECT} --branch=master "
$TRIGGER_RUN "01-meta-project-apply-${PROJECT}"
