#!/bin/bash

# prbranch.sh
# A script to finish work on a Git branch, committing changes, pushing to GitHub,
# and guiding the user to create a Pull Request.

# --- Configuration ---
DEFAULT_MAIN_BRANCH="main" # Set your default main branch name here (e.g., 'main', 'master')
# ---------------------

# --- Function to display usage ---
display_usage() {
    echo "Usage: $0 \"<commit_message>\" [main_branch_name]"
    echo ""
    echo "  \"<commit_message>\" : The message for your commit (e.g., \"feat: Add new awesome feature\")."
    echo "  [main_branch_name] : (Optional) The name of your main branch, defaults to '$DEFAULT_MAIN_BRANCH'."
    echo ""
    echo "This script assumes you have already run 'mkbranch.sh',"
    echo "made your changes, and staged them ('git add .')."
    echo "It will then:"
    echo "1. Commit your staged changes."
    echo "2. Push your current local branch to the remote."
    echo "3. Guide you to create a Pull Request on GitHub."
    exit 1
}

# --- Check for arguments ---
if [ "$#" -lt 1 ]; then
    display_usage
fi

COMMIT_MESSAGE="$1"
MAIN_BRANCH_NAME="${2:-$DEFAULT_MAIN_BRANCH}" # Use provided main branch name or default

# Determine current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -z "$CURRENT_BRANCH" ]; then
    echo "Error: Not in a Git repository or no branch checked out. Exiting."
    exit 1
fi

echo "--- Git Workflow: Finish Branch Work ---"
echo "Current Branch     : $CURRENT_BRANCH"
echo "Commit Message     : '$COMMIT_MESSAGE'"
echo "Main Branch Name   : $MAIN_BRANCH_NAME"
echo "----------------------------------------"
echo ""

# 1. Commit changes
echo "1. Checking for staged changes before committing..."

# --- MODIFIED CHECK HERE ---
# Use 'git status --porcelain' to check for staged changes (index status)
# A line starting with 'M ', 'A ', 'D ', 'R ', 'C ' in the first column means staged changes.
if [ -z "$(git status --porcelain | grep -E '^[MADRC][ ]')" ]; then
    echo "No changes staged. Please ensure you have staged your changes using 'git add .' before running this script."
    echo "Exiting script."
    exit 1
fi
# --- END MODIFIED CHECK ---

echo "   Committing staged changes..."
git commit -m "$COMMIT_MESSAGE" || { echo "Error: Failed to commit changes. Exiting."; exit 1; }
echo "   Changes committed successfully."
echo ""

# 2. Push current branch to GitHub
echo "2. Pushing '$CURRENT_BRANCH' branch to GitHub..."
git push -u origin "$CURRENT_BRANCH" || { echo "Error: Failed to push branch. Check your connection/permissions or resolve any local/remote conflicts by first pulling. Exiting."; exit 1; }
echo "   Branch '$CURRENT_BRANCH' pushed to GitHub."
echo ""

# 3. Guide to create Pull Request
REPO_URL=$(git remote get-url origin 2>/dev/null | sed 's/\.git$//') # Get repo URL and remove .git
if [ -z "$REPO_URL" ]; then
    echo "Warning: Could not determine GitHub repository URL from 'origin' remote."
    echo "Please manually go to github.com/your-username/your-repo to create the PR."
else
    echo "-------------------------------------------------------------"
    echo ">>> STEP 3: CREATE A PULL REQUEST ON GITHUB <<<"
    echo "Your branch '$CURRENT_BRANCH' is now on GitHub."
    echo "Please visit your repository URL to create the Pull Request:"
    echo "   $REPO_URL/compare/$MAIN_BRANCH_NAME...$CURRENT_BRANCH"
    echo ""
    echo "Or go to $REPO_URL and look for the 'Compare & pull request' button."
    echo "-------------------------------------------------------------"
fi

echo "--- 'finish_branch_work.sh' Finished ---"
echo "Good luck with your Pull Request!"