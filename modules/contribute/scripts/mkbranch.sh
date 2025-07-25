#!/bin/bash
# User-configurable variables - modify as needed
USER="${USER}"
USER_EMAIL="${USER}@${COMPANY_DOMAIN:-example.com}"
COMPANY_NAME="${COMPANY_NAME:-Your Company}"
COMPANY_DOMAIN="${COMPANY_DOMAIN:-example.com}"


# mkbranch.sh
# A script to create a new Git branch for development, ensuring the main branch is up-to-date,
# and prompting the user to manually make and stage their changes.

# --- Configuration ---
DEFAULT_MAIN_BRANCH="main" # Set your default main branch name here (e.g., 'main', 'master')
# ---------------------

# --- Function to display usage ---
display_usage() {
    echo "Usage: $0 <new_branch_name> [main_branch_name]"
    echo ""
    echo "  <new_branch_name>  : The name of the new branch to create (e.g., 'rxx-br')."
    echo "  [main_branch_name] : (Optional) The name of your main branch, defaults to '$DEFAULT_MAIN_BRANCH'."
    echo ""
    echo "This script will:"
    echo "1. Ensure your '$DEFAULT_MAIN_BRANCH' branch is up-to-date."
    echo "2. Create and switch to your new branch."
    echo "3. PROMPT YOU TO MANUALLY MAKE AND STAGE YOUR CHANGES."
    echo ""
    echo "After making your changes and staging them (git add .), you will run 'finish_branch_work.sh'."
    exit 1
}

# --- Check for arguments ---
if [ "$#" -lt 1 ]; then
    display_usage
fi

NEW_BRANCH_NAME="$1"
MAIN_BRANCH_NAME="${2:-$DEFAULT_MAIN_BRANCH}" # Use provided main branch name or default

echo "--- Git Workflow: Start Work on New Branch ---"
echo "New Branch Name    : $NEW_BRANCH_NAME"
echo "Main Branch Name   : $MAIN_BRANCH_NAME"
echo "----------------------------------------------"
echo ""

# 1. Ensure local main is up-to-date
echo "1. Ensuring local '$MAIN_BRANCH_NAME' branch is up-to-date..."
git checkout "$MAIN_BRANCH_NAME" || { echo "Error: Could not checkout $MAIN_BRANCH_NAME. Exiting."; exit 1; }
git pull origin "$MAIN_BRANCH_NAME" || { echo "Error: Failed to pull from origin/$MAIN_BRANCH_NAME. Resolve conflicts if any. Exiting."; exit 1; }
echo "   '$MAIN_BRANCH_NAME' branch is up-to-date."
echo ""

# 2. Create and switch to new branch
echo "2. Creating and switching to new branch: '$NEW_BRANCH_NAME'..."
git checkout -b "$NEW_BRANCH_NAME" || { echo "Error: Could not create/checkout branch $NEW_BRANCH_NAME. Exiting."; exit 1; }
echo "   Switched to branch '$NEW_BRANCH_NAME'."
echo ""

# 3. Prompt for manual changes
echo "-------------------------------------------------------------"
echo ">>> STEP 3: MANUALLY MAKE YOUR CHANGES AND STAGE THEM <<<"
echo "Use your code editor to modify/add/delete files."
echo "Then, use 'git add .' or 'git add <files>' to stage your changes."
echo ""
echo "DO NOT PROCEED PAST THIS POINT IN THE SCRIPT."
echo "Once you have made and staged your changes, run:"
echo "    ./prbranch.sh \"Your commit message here\""
echo "-------------------------------------------------------------"

echo "--- 'start_work_on_branch.sh' Finished ---"
echo "Ready for you to start coding on branch '$NEW_BRANCH_NAME'."