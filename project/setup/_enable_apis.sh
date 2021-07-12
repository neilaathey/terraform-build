#!/bin/bash

if [[ $# -ne 1 ]] ; then
    echo "Usage: _enable_apis.sh <project>"
    exit 1
fi

PROJECT=$1

ENABLE_API="gcloud --project=$PROJECT services enable "
 
$ENABLE_API iam.googleapis.com
$ENABLE_API cloudbuild.googleapis.com
$ENABLE_API deploymentmanager.googleapis.com
$ENABLE_API cloudresourcemanager.googleapis.com
$ENABLE_API cloudkms.googleapis.com
$ENABLE_API sourcerepo.googleapis.com
$ENABLE_API cloudfunctions.googleapis.com
$ENABLE_API dataflow.googleapis.com
$ENABLE_API cloudscheduler.googleapis.com
$ENABLE_API secretmanager.googleapis.com
