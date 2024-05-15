#!/bin/bash

# Ensure script exits if any command fails
set -e

# Function to display usage instructions
usage() {
    echo "Usage: $0 -u <username> -p <password> -m <commit_message>"
    exit 1
}

# Parse command-line arguments
while getopts ":u:p:m:" opt; do
  case ${opt} in
    u )
      username=$OPTARG
      ;;
    p )
      password=$OPTARG
      ;;
    m )
      commit_message=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if username, password, and commit message are provided
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$commit_message" ]; then
    echo "Error: Username, password, and commit message are required."
    usage
fi

# Add changes to git
echo "Adding changes to git..."
git add .

# Commit changes
echo "Committing changes with message: '$commit_message'"
git commit -m "$commit_message"

# Push changes to remote repository
# Using the username and password provided for HTTP Basic Authentication
echo "Pushing changes to remote repository..."
remote_url=$(git config --get remote.origin.url)

# Check if the remote URL contains 'https'
if [[ $remote_url == https* ]]; then
    remote_url_with_creds="https://$username:$password@${remote_url#https://}"
else
    echo "Error: The remote URL is not using HTTPS. Cannot add credentials."
    exit 1
fi

git push "$remote_url_with_creds"

echo "Operation completed successfully."

