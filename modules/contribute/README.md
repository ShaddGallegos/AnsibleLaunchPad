# Git Workflow Automation Scripts

This repository contains a set of simple Bash scripts designed to streamline common Git development workflows. These scripts help automate the repetitive commands involved in creating branches, making changes, committing, pushing, creating pull requests, and cleaning up branches.

## Setup

Before using these scripts, you need to:

1.  **Save the scripts:** Place `mkbranch.sh`, `prbranch.sh`, and `rmbranch.sh` in the root directory of your Git repository (or in a directory included in your system's `PATH`).
2.  **Make them executable:**
    ```bash
    chmod +x mkbranch.sh prbranch.sh rmbranch.sh
    ```

**Note on Default Branch:** Each script assumes your default main branch is named `main`. If your main branch is named `master` or something else, you can pass its name as an optional last argument to the scripts.

---

## 1. `mkbranch.sh` - Start Work on a New Branch

This script initiates a new feature development cycle. It ensures your local `main` branch is up-to-date with the remote, then creates and switches to a new feature branch based on `main`. It then pauses, prompting you to perform your actual code changes and stage them for commit.

### What it does:
* Switches to your default main branch (e.g., `main`).
* Pulls the latest changes for the main branch from `origin`.
* Creates a new branch with the specified name and switches to it.
* Instructs you to manually make your code changes and stage them using `git add .` (or specific files).
* **Important:** This script stops here, waiting for your manual development work.

### Usage:

```bash
./mkbranch.sh <new_branch_name> [main_branch_name]
````

  * `<new_branch_name>`: The name you want for your new feature branch (e.g., `feat/user-auth`).
  * `[main_branch_name]`: (Optional) Specify your main branch name if it's not `main` (e.g., `master`).

### Usage Examples:

1.  **Create a new branch named `rxx-br` (assuming `main` is your default):**

    ```bash
    ./mkbranch.sh rxx-br
    ```

2.  **Create a new branch named `bugfix/login-issue` (assuming `main` is your default):**

    ```bash
    ./mkbranch.sh bugfix/login-issue
    ```

3.  **Create a new branch named `feature/new-dashboard` when your main branch is `master`:**

    ```bash
    ./mkbranch.sh feature/new-dashboard master
    ```

-----

## 2\. `prbranch.sh` - Commit, Push, and Create Pull Request

This script continues the workflow after you have manually made and staged your changes using `mkbranch.sh`. It commits your staged changes, pushes the new branch to your GitHub repository, and provides a direct link to create a Pull Request.

### What it does:

  * Checks if there are staged changes ready for commit.
  * Commits the staged changes with the provided commit message.
  * Pushes your current local branch to your `origin` remote on GitHub.
  * Generates a convenient URL to directly open the Pull Request creation page on GitHub for your new branch.

### Usage:

```bash
./prbranch.sh "<commit_message>" [main_branch_name]
```

  * `"<commit_message>"`: A descriptive message for your commit (e.g., `"feat: Implement user login functionality"`). **Remember to enclose it in double quotes if it contains spaces.**
  * `[main_branch_name]`: (Optional) Specify your main branch name if it's not `main`.

### Usage Examples:

1.  **Commit staged changes and push (assuming `main` is your default branch):**

    ```bash
    ./prbranch.sh "feat: Added initial user authentication module"
    ```

2.  **Commit staged changes with a fix message and push (assuming `main` is your default branch):**

    ```bash
    ./prbranch.sh "fix: Corrected button styling on contact form"
    ```

3.  **Commit staged changes and push when your main branch is `master`:**

    ```bash
    ./prbranch.sh "docs: Updated README with setup instructions" master
    ```

-----

## 3\. `rmbranch.sh` - Cleanup and Sync

This script is used to clean up a feature branch after it has been merged into your main branch (or is no longer needed). It also ensures your local repository is fully synchronized with your GitHub remote.

### What it does:

  * Switches to your default main branch (e.g., `main`).
  * Attempts to delete the specified feature branch locally. It will warn you if the branch has unmerged changes.
  * Deletes the specified feature branch from your `origin` remote on GitHub.
  * Pulls the latest changes for your default main branch to ensure it's up-to-date.
  * Fetches all remote branches and prunes any stale remote-tracking branches (those that no longer exist on the remote).

### Usage:

```bash
./rmbranch.sh <branch_to_delete> [main_branch_name]
```

  * `<branch_to_delete>`: The name of the branch you want to delete (e.g., `rxx-br`).
  * `[main_branch_name]`: (Optional) Specify your main branch name if it's not `main`.

### Usage Examples:

1.  **Delete `rxx-br` after it has been merged (assuming `main` is your default branch):**

    ```bash
    ./rmbranch.sh rxx-br
    ```

2.  **Delete `bugfix/old-bug` after it's no longer needed (assuming `main` is your default branch):**

    ```bash
    ./rmbranch.sh bugfix/old-bug
    ```

3.  **Delete `feature/experimental-feature` when your main branch is `master`:**

    ```bash
    ./rmbranch.sh feature/experimental-feature master
    ```

-----

## Complete Workflow Example:

Here's how you'd typically use these three scripts in sequence for a new feature development cycle:

1.  **Start a new feature branch and prepare for coding (e.g., `my-new-awesome-feature`):**

    ```bash
    ./mkbranch.sh my-new-awesome-feature
    ```

      * *(At this point, the script pauses. You then manually open your editor, write your code, modify files, etc.)*

2.  **After coding, stage your changes:**

    ```bash
    git add .
    ```

      * *(Optional: You can run `git status` to confirm your changes are staged.)*

3.  **Commit your changes, push the branch to GitHub, and get the Pull Request link:**

    ```bash
    ./prbranch.sh "feat: Implemented the new awesome feature"
    ```

      * *(The script will output a GitHub URL. Visit this URL in your web browser to finalize and create your Pull Request.)*

4.  **After your Pull Request is reviewed and merged into `main` (on GitHub):**

    ```
    ./rmbranch.sh my-new-awesome-feature
    ```

      * *(This cleans up the feature branch both locally and remotely, and updates your local `main` branch to the latest state.)*

```