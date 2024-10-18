#!/bin/bash

TOKEN="*****"  
OrgName="MTNNigeria"
REPO="NextGen-Settlement"  
BASE_URL="https://api.github.com"
BASE_BRANCH_NAME="main"
NEW_BRANCH_NAME="dev"

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://$BASE_URL/repos/$OrgName/$REPO/git/refs \
  -d '{"ref":"refs/heads/stage","sha":"52093d9ccc689e0f8e4f987df3adcfb176b4a9ca"}'






  #!/bin/bash

TOKEN="*****"  
OrgName="MTNNigeria"
REPO="NextGen-Settlement"  
BASE_URL="https://api.github.com"
BASE_BRANCH_NAME="main"
NEW_BRANCH_NAME="stage"  # Change this to the name of the new branch

# Step 1: Get the latest SHA of the base branch (main)
BASE_SHA=$(curl -s \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  $BASE_URL/repos/$OrgName/$REPO/git/ref/heads/$BASE_BRANCH_NAME | jq -r '.object.sha')

if [ -z "$BASE_SHA" ]; then
  echo "Error: Failed to fetch the base branch SHA. Please check the repository and branch names."
  exit 1
fi

# Step 2: Create the new branch using the SHA from the base branch
curl -s \
  -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  $BASE_URL/repos/$OrgName/$REPO/git/refs \
  -d "{\"ref\":\"refs/heads/$NEW_BRANCH_NAME\",\"sha\":\"$BASE_SHA\"}"

echo "New branch '$NEW_BRANCH_NAME' created based on '$BASE_BRANCH_NAME' with SHA $BASE_SHA."
