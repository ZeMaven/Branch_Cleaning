#!/bin/bash

# GitHub Personal Access Token
TOKEN="*********"

# GitHub branch
BRANCHES=("dev")
# BRANCH=("dev" "stage" "main" "")

# GitHub username or organization
OWNER="MTNNigeria"

# File containing the list of repositories
REPO_FILE="phase4.txt"

# Loop through each repository listed in the file and add the branch protection
while IFS= read -r REPO || [[ -n "$REPO" ]]; do
    REPO=$(echo "$REPO" | xargs)
    # Check if REPO is not empty and does not contain invalid characters
    if [[ -n "$REPO" && "$REPO" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Processing repository: $REPO..."

        # Loop through each collaborator and add them to the current repository
        for BRANCH in "${BRANCHES[@]}"; do

            echo "Adding branch protection to $REPO..."

    curl -L \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH/protection \
    -d '{"required_status_checks":null,"required_pull_request_reviews":{"dismissal_restrictions":{"users":["octocat"],"teams":["justice-league"]},"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"required_approving_review_count":2,"require_last_push_approval":true,"bypass_pull_request_allowances":{"users":["octocat"],"teams":["justice-league"]}},"restrictions":{"users":["octocat"],"teams":["justice-league"],"apps":["super-ci"]},"required_linear_history":true,"allow_force_pushes":true,"allow_deletions":true,"block_creations":true,"required_conversation_resolution":true,"lock_branch":true,"allow_fork_syncing":true}'

            # Add a 2-second delay after adding each collaborator
            sleep 2
        done

        # Add a 4-second delay after processing each repository
    sleep 4

    else
        echo "Empty or invalid repo name found, skipping..."
    fi
done < "$REPO_FILE"
