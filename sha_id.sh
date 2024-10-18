#!/bin/bash

TOKEN="******"  
OrgName="MTNNigeria"
REPO="NextGen-Settlement"  
BASE_URL="https://api.github.com"
Previous_branch_name="dev"
New_branch_name="dev"

# # Get the SHA of the previous branch (main branch)
SHA=$(curl -s -H "Authorization: token $TOKEN" "$BASE_URL/repos/$OrgName/$REPO/git/refs/heads/$Previous_branch_name" | jq -r '.object.sha')

# # Step 1: Get the latest commit SHA of the base branch (e.g., 'main')
# SHA=$(curl -s -H "Authorization: token $TOKEN" \
#      "$BASE_URL/repos/$OWNER/$REPO/git/refs/heads/$Previous_branch_name" | jq -r '.object.sha')

# Check if the SHA was fetched successfully
if [ -z "$SHA" ]; then
    echo "Error: Unable to fetch the SHA of the branch '$Previous_branch_name'. Please check your token, organization name, and repository name."
    exit 1
fi

# Print the SHA
echo "SHA of the branch '$Previous_branch_name': $SHA"
