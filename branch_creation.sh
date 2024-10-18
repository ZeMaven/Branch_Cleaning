#!/bin/bash

TOKEN="******"  
OrgName="MTNNigeria"
Previous_branch_name="main"
New_branch_name="dev"
REPO_FILE="repos.txt"

while IFS= read -r REPO || [[ -n "$REPO" ]]; do
  REPO=$(echo "$REPO" | xargs)
  echo "Processing repository: $REPO..."

  # Check if the branch already exists
  BRANCH_EXISTS=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/$REPO/git/refs/heads/$New_branch_name | jq -r '.ref')

  if [ "$BRANCH_EXISTS" == "refs/heads/$New_branch_name" ]; then
    echo "Branch '$New_branch_name' already exists for repository $REPO."
  else
    # Get the SHA of the previous branch (main in this case)
    SHA=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/$REPO/git/refs/heads/$Previous_branch_name | jq -r '.object.sha')

    # Create the new branch
    if [ -n "$SHA" ]; then
      curl -X POST -H "Authorization: token $TOKEN" \
      -d "{\"ref\": \"refs/heads/$New_branch_name\",\"sha\": \"$SHA\"}" \
      https://api.github.com/repos/$REPO/git/refs
      echo "Branch '$New_branch_name' created successfully for repository $REPO."
    else
      echo "Failed to get the SHA for branch '$Previous_branch_name' in repository $REPO."
    fi
  fi

  sleep 2

done < "$REPO_FILE"