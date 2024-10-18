#!/bin/bash

OrgName="MTNNigeria"
PATToken="******"

RepoFile="repo_file.txt"
OutputFile="repository_branches.csv"

# Write the header to the CSV file
echo "Repository,Branch,Last Commit Date" > "$OutputFile"

# Read the file line by line
while IFS= read -r repoName || [[ -n "$repoName" ]]; do
  # Trim whitespace from the repo name
  repoName=$(echo "$repoName" | xargs)

  # Fetch branches for the current repository
  branches=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $PATToken" \
    "https://api.github.com/repos/$OrgName/$repoName/branches")

  # Check if the response contains branches (i.e., if the repository exists)
  if [[ $(echo "$branches" | jq '. | length') -gt 0 ]]; then
    # Loop through each branch and fetch the last commit date
    for branch in $(echo "$branches" | jq -r '.[] | @base64'); do
      _jq() {
        echo "$branch" | base64 --decode | jq -r "$1"
      }

      branchName=$(_jq '.name')

      # Fetch the last commit date for the current branch
      lastCommit=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $PATToken" \
        "https://api.github.com/repos/$OrgName/$repoName/commits/$branchName")

      # Extract the last commit date
      lastCommitDate=$(echo "$lastCommit" | jq -r '.commit.committer.date')

      # Write to the CSV file
      echo "$repoName,$branchName,$lastCommitDate" >> "$OutputFile"
    done
  else
    # If the repo is not found or no branches exist, log it in the CSV
    echo "$repoName,No branches or repo not found,N/A" >> "$OutputFile"
  fi
done < "$RepoFile"

echo "Branches with last commit dates have been written to $OutputFile"
