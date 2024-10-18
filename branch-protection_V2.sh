#!/bin/bash

# GitHub Personal Access Token
TOKEN="******"

# GitHub branch
BRANCHES=("coralpayupdates_dev")
# BRANCHES=("dev" "stage" "main" "")

# GitHub username or organization
OWNER="MTNNigeria"

# File containing the list of repositories
REPO_FILE="repo_file.txt"

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
    -d '{"required_status_checks":null,"enforce_admins":false,"required_pull_request_reviews":{"dismissal_restrictions":{"users":[],"teams":[]},"dismiss_stale_reviews":false,"require_code_owner_reviews":false,"required_approving_review_count":1,"require_last_push_approval":false,"bypass_pull_request_allowances":{"users":[],"teams":[]}},"restrictions":null,"required_linear_history":false,"allow_force_pushes":false,"allow_deletions":false,"block_creations":false,"required_conversation_resolution":false,"lock_branch":false,"allow_fork_syncing":false}'

            # Add a 2-second delay after adding each branch protection
            sleep 2
        done

        # Add a 4-second delay after processing each repository
    sleep 4

    else
        echo "Empty or invalid repo name found, skipping..."
    fi
done < "$REPO_FILE"