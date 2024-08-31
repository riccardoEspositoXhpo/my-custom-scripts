#!/bin/bash

# source utilities
source "$LINUXTOOLKITDIR/custom-scripts/utilities.sh"

# help menu
usage() {
    echo "This script automagically pulls a git repository."
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  --repo          Repository to pull. Defaults to current directory. Will attempt to locate it on the system via the .git folder"
    exit 0
}

# initialize variables
IS_CUSTOM_REPO=false

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        --repo)
            IS_CUSTOM_REPO=true
            CUSTOM_REPO_NAME="$2"
            shift  # Shift past the argument value
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift  # Shift past the argument
done

# set default directory for git
REPO_PATH="$(dirname "$(realpath "$0")")"

# Check if a repository name was passed as an argument
if [ "$IS_CUSTOM_REPO" = true ]; then
    # Find the repository by name
    REPO_PATH=$(find_repo_by_name "$CUSTOM_REPO_NAME")

    if [ -n "$REPO_PATH" ]; then
        # If a repository is found, navigate to it
        echo "Found repository: $REPO_PATH"

    else
        # If no repository is found, report an error and exit
        echo "Repository $CUSTOM_REPO_NAME not found."
        exit 1
    fi
fi

cd "$REPO_PATH" || { echo "Directory not found: $REPO_PATH"; exit 1; }

# Pull the latest changes from the remote repository
git pull origin "$(git rev-parse --abbrev-ref HEAD)"

# Output success message
echo "Repository updated successfully."

exit 0