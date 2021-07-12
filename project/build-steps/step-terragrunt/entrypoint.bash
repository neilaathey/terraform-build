#!/bin/bash
TYPE="$1"
ARGS=("${@:2}")
PROJECT_ID="${PROJECT_ID:-$(gcloud config get-value project 2>/dev/null)}"
PULL_REQUEST_ID="${PULL_REQUEST_ID}"
GH_SECRET_NAME="${GH_SECRET_NAME:-github-robot-token}"
GH_SECRET_VERSION="${GH_SECRET_VERSION:-latest}"
PARALLELISM="${PARALLELISM:-100}"
BRANCH="${BRANCH:-fix-your-cloudbuild}"
REPO_NAME="${REPO_NAME:-neilaathey/terraform-build}"
if [[ "$PROJECT_ID" =~ -prd$ ]]; then
    POST_PR_OUTPUT="${POST_PR_OUTPUT:-1}"
    GH_SECRET_PROJECT="${GH_SECRET_PROJECT:-bi-shared-secrets-prd}"
else
    POST_PR_OUTPUT="${POST_PR_OUTPUT:-0}"
    GH_SECRET_PROJECT="${GH_SECRET_PROJECT:-bi-shared-secrets-dev}"
fi
if [[ "$TYPE" == "destroy" ]]; then
    DESTROY_FLAG="-destroy"
else
    DESTROY_FLAG=""
fi

echo "################ Project_ID:-${PROJECT_ID}"
echo "Initialising terraform in docker image"

terraform init -input=false -lock-timeout=5m -backend-config="bucket=tfstate-${PROJECT_ID}" || exit 1

if [[ -f "tmp/import-${PROJECT_ID}.sh" ]]; then
    cat <<EOF > "tmp/import-${PROJECT_ID}-sanitized.sh"
#!/bin/bash
export GOOGLE_CLOUD_PROJECT="${PROJECT_ID}"
EOF
    grep -E "^terraform (import|state)" "tmp/import-${PROJECT_ID}.sh" >> "tmp/import-${PROJECT_ID}-sanitized.sh"
    chmod +x tmp/import-${PROJECT_ID}-sanitized.sh
    tmp/import-${PROJECT_ID}-sanitized.sh
fi

terraform plan -input=false -lock=false -compact-warnings -no-color -parallelism="${PARALLELISM}" -var="project_id=${PROJECT_ID}" "${ARGS[@]}" $DESTROY_FLAG | tee output_full
EXIT_STATUS="${PIPESTATUS[0]}"

grep -v 'Refreshing state...' output_full > output

if [[ "$EXIT_STATUS" == "1" ]]; then
    echo "PLAN FAILED - CHECK BUILD OUTPUT" >> output
fi

if [[ "$TYPE" == "plan" ]]; then
    if [[ "$POST_PR_OUTPUT" == "1" ]]; then
        gcloud secrets versions access "${GH_SECRET_VERSION}" \
            --secret="${GH_SECRET_NAME}" \
            --project="${GH_SECRET_PROJECT}" > token
        python3 /builder/post_plan.py "$PULL_REQUEST_ID" "$PROJECT_ID" "$REPO_NAME"
    else
        echo "Plan completed."
    fi
elif [[ "$TYPE" == "apply" || "$TYPE" == "destroy" ]]; then
    if [[ "$PROJECT_ID" =~ -prd$ && ! "$BRANCH" =~ ^master$ ]]; then
        echo "Terraform on prd projects can be applied only from master branch! Current branch is $BRANCH"
        exit 1
    elif [[ "$PROJECT_ID" =~ -prd$ && "$TYPE" == "destroy" ]]; then
        echo "Destroy is not allowed on prd project!"
        exit 1
    else
        terraform "$TYPE" -input=false -lock-timeout=5m -auto-approve -parallelism="${PARALLELISM}" -var="project_id=${PROJECT_ID}" "${ARGS[@]}"
    fi
    EXIT_STATUS="$?"
else
    echo "Unknown value ${1}: valid options are plan, apply" && exit 1
fi

exit $EXIT_STATUS
