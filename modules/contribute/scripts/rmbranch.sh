#!/bin/bash

# rmbranch.sh
# A script to clean up and sync a Git repository by deleting a specified branch both locally and remotely,
# while ensuring the main branch is up-to-date and fetching all remote branches.

# --- Configuration ---
DEFAULT_MAIN_BRANCH="main" # Set your default main branch name here (e.g., 'main', 'master')
# ---------------------

# --- Function to display usage ---
display_usage() {
    echo "Usage: $0 <branch_to_delete> [main_branch_name]"
    echo ""
    echo "  <branch_to_delete> : The name of the branch you want to delete (e.g., 'rxx-br')."
    echo "  [main_branch_name] : (Optional) The name of your default main branch, defaults to '$DEFAULT_MAIN_BRANCH'."
    echo ""
    echo "This script will:"
    echo "1. Switch to your default main branch ('$DEFAULT_MAIN_BRANCH' by default)."
    echo "2. Delete the specified branch locally."
    echo "3. Delete the specified branch from your 'origin' remote on GitHub."
    echo "4. Pull the latest changes for your default main branch from GitHub."
    echo "5. Fetch all remote branches to ensure your local remote-tracking branches are up-to-date."
    exit 1
}

# --- Check for arguments ---
if [ "$#" -lt 1 ]; then
    display_usage
fi

BRANCH_TO_DELETE="$1"
MAIN_BRANCH_NAME="${2:-$DEFAULT_MAIN_BRANCH}" # Use provided main branch name or default

echo "--- Git Cleanup and Sync Script ---"
echo "Branch to Delete   : $BRANCH_TO_DELETE"
echo "Default Main Branch: $MAIN_BRANCH_NAME"
echo "-----------------------------------"
echo ""

# 1. Switch to the default main branch
echo "1. Switching to '$MAIN_BRANCH_NAME' branch..."
git checkout "$MAIN_BRANCH_NAME" || { echo "Error: Could not checkout '$MAIN_BRANCH_NAME'. Please resolve any issues. Exiting."; exit 1; }
echo "   Switched to '$MAIN_BRANCH_NAME'."
echo ""

# 2. Delete the specified branch locally
echo "2. Attempting to delete local branch: '$BRANCH_TO_DELETE'..."
# Use -d for safe deletion (only if merged), -D for forced deletion
if git branch -d "$BRANCH_TO_DELETE"; then
    echo "   Local branch '$BRANCH_TO_DELETE' deleted successfully (it was merged)."
elif git branch -D "$BRANCH_TO_DELETE"; then
    echo "   Local branch '$BRANCH_TO_DELETE' deleted successfully (forced deletion due to unmerged changes)."
    echo "   WARNING: Forced deletion means some changes might not have been merged. Proceed with caution."
else
    echo "   Warning: Local branch '$BRANCH_TO_DELETE' not found or could not be deleted. Continuing..."
fi
echo ""

# 3. Delete the specified branch from the remote (GitHub)
echo "3. Attempting to delete remote branch: 'origin/$BRANCH_TO_DELETE'..."
if git push origin --delete "$BRANCH_TO_DELETE"; then
    echo "   Remote branch 'origin/$BRANCH_TO_DELETE' deleted successfully."
else
    echo "   Warning: Remote branch 'origin/$BRANCH_TO_DELETE' not found or could not be deleted. It might already be gone."
fi
echo ""

# 4. Pull the latest changes for the default main branch
echo "4. Pulling latest changes for '$MAIN_BRANCH_NAME' from GitHub..."
git pull origin "$MAIN_BRANCH_NAME" || { echo "Error: Failed to pull from origin/$MAIN_BRANCH_NAME. Resolve conflicts if any. Exiting."; exit 1; }
echo "   '$MAIN_BRANCH_NAME' branch is now up-to-date with GitHub."
echo ""

# 5. Fetch all remote branches (to clean up remote-tracking branches locally)
echo "5. Fetching all remote branches to update local tracking references..."
git fetch --all --prune || { echo "Error: Failed to fetch all remote branches. Exiting."; exit 1; }
echo "   All remote branches fetched and pruned."
echo ""

echo "--- Script Finished ---"
echo "Your repository should now be clean and synced."