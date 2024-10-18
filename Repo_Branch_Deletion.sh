#!/bin/bash

PATToken="******"
OrgName="MTNNigeria"
BASE_URL="https://api.github.com"
THRESHOLD=$((6 * 30 * 24 * 60 * 60))
CURRENT_DATE=$(date +%s)

# Function to check if a branch is stale
is_stale() {
    LAST_COMMIT_DATE=$1
    LAST_COMMIT_EPOCH=$(date -d "$LAST_COMMIT_DATE" +%s)
    DIFF=$((CURRENT_DATE - LAST_COMMIT_EPOCH))

    # Check if the difference exceeds the threshold
    if [ $DIFF -ge $THRESHOLD ]; then
        return 0  # Stale
    else
        return 1  # Active
    fi
}

# Function to delete stale branches in a repository
delete_stale_branches() {
    REPO_NAME=$1
    echo "Checking repository: $REPO_NAME"

    # Fetch all branches in the repository
    BRANCHES=$(curl -s -H "Authorization: token $PATToken" "$BASE_URL/repos/$OrgName/$REPO_NAME/branches" | jq -r '.[] | @base64')

    for branch in $BRANCHES; do
        _jq() {
            echo "$branch" | base64 --decode | jq -r "$1"
        }

        BRANCH_NAME=$(_jq '.name')
        LAST_COMMIT_DATE=$(curl -s -H "Authorization: token $PATToken" "$BASE_URL/repos/$OrgName/$REPO_NAME/commits/$BRANCH_NAME" | jq -r '.commit.committer.date')

        if is_stale "$LAST_COMMIT_DATE"; then
            echo "Branch '$BRANCH_NAME' is stale (last commit: $LAST_COMMIT_DATE), deleting..."
            curl -s -X DELETE -H "Authorization: token $PATToken" "$BASE_URL/repos/$OrgName/$REPO_NAME/git/refs/heads/$BRANCH_NAME"
        else
            echo "Branch '$BRANCH_NAME' is active."
        fi
    done
}

# Loop through each repository
for repo in $(curl -s -H "Authorization: token $PATToken" "$BASE_URL/orgs/$OrgName/repos?per_page=100" | jq -r '.[].name'); do
    delete_stale_branches "$repo"
done
