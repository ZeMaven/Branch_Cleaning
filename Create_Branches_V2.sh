#!/bin/bash

# Set up the branch names
MAIN_BRANCH="main"
STAGING_BRANCH="stage"
DEVELOPMENT_BRANCH="dev"
RELEASE_BRANCH="releases"
FEATURE_BRANCH="feature/new-feature"

# Your GitHub organization/owner
OrgName="MTNNigeria"

# Your GitHub PAT token (ensure this is secure)
PATToken="*****"

# Path to the repositories file (containing only repo names, e.g., repo1, repo2)
REPOS_FILE="repos.txt"

# Directory to clone the repositories temporarily
TEMP_DIR="temp_repos"

# Create a directory to store the cloned repositories
mkdir -p $TEMP_DIR

# Function to create or switch branches in a repository
create_branches() {
    REPO_NAME=$1
    REPO_URL="https://$PATToken@github.com/$OrgName/$REPO_NAME.git"
    REPO_DIR="$TEMP_DIR/$REPO_NAME"

    echo "Processing repository: $REPO_NAME"

    # Clone the repository using the PAT for authentication
    git clone "$REPO_URL" "$REPO_DIR" || { echo "Failed to clone $REPO_NAME"; return; }

    # Navigate into the cloned repository
    cd "$REPO_DIR" || exit

    # Function to create or switch to a branch
    create_or_switch_branch() {
        BRANCH_NAME=$1
        if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
            echo "Branch '$BRANCH_NAME' already exists, switching to it."
            git checkout "$BRANCH_NAME" || { echo "Failed to switch to branch $BRANCH_NAME"; return; }
        else
            echo "Creating and switching to branch '$BRANCH_NAME'."
            git checkout -b "$BRANCH_NAME" || { echo "Failed to create branch $BRANCH_NAME"; return; }
        fi
        git push origin "$BRANCH_NAME" || { echo "Failed to push branch $BRANCH_NAME"; return; }
    }

    # Create or switch to each branch and push it to remote
    create_or_switch_branch "$MAIN_BRANCH"
    create_or_switch_branch "$STAGING_BRANCH"
    create_or_switch_branch "$DEVELOPMENT_BRANCH"
    create_or_switch_branch "$RELEASE_BRANCH"
    create_or_switch_branch "$FEATURE_BRANCH"

    # Go back to the initial directory
    cd - || exit

    echo "Finished processing repository: $REPO_NAME"
}

# Loop through each repository name in the file and create branches
while IFS= read -r REPO_NAME; do
    # Check if the line is not empty
    if [ -n "$REPO_NAME" ]; then
        create_branches "$REPO_NAME"
    fi
done < "$REPOS_FILE"

# Clean up the temporary repository folder
rm -rf "$TEMP_DIR"

echo "All repositories processed."
