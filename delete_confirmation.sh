#!/bin/bash

PATToken="******"
OrgName="MTNNigeria"
BASE_URL="https://api.github.com"
REPO_NAME="Activity-Tracker-Frontend"

curl -s -H "Authorization: token $PATToken" "https://api.github.com/repos/$OrgName/$REPO_NAME/branches"
