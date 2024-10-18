#!/bin/bash

# GitHub Personal Access Token
TOKEN="*********"

# GitHub username of the collaborators
COLLABORATORS=("ilvesuzo")
# COLLABORATORS=("ilvvikas7724esuzo" "michaelyhello" "moona16" "")

# GitHub username or organization
OWNER="MTNNigeria"

# File containing the list of repositories
REPO_FILE="phase4.txt"

# Loop through each repository listed in the file and add the collaborators
while IFS= read -r REPO || [[ -n "$REPO" ]]; do
    REPO=$(echo "$REPO" | xargs)
    # Check if REPO is not empty and does not contain invalid characters
    if [[ -n "$REPO" && "$REPO" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Processing repository: $REPO..."

        # Loop through each collaborator and add them to the current repository
        for COLLABORATOR in "${COLLABORATORS[@]}"; do

            echo "Adding $COLLABORATOR to $REPO..."

    curl -L \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/$OWNER/$REPO/collaborators/$COLLABORATOR \
    -d '{"permission":"write"}'

            # Add a 2-second delay after adding each collaborator
            sleep 2
        done

        # Add a 4-second delay after processing each repository
    sleep 4

    else
        echo "Empty or invalid repo name found, skipping..."
    fi
done < "$REPO_FILE"
