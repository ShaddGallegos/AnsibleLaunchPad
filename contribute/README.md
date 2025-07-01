# Git Workflow Automation Scripts

This repository contains a set of simple Bash scripts designed to streamline common Git development workflows, especially when interacting with GitHub. These scripts help automate the repetitive commands involved in creating branches, making changes, committing, pushing, creating pull requests, and cleaning up branches.

## Setup

Before using these scripts, you need to:

1.  **Save the scripts:** Place `mkbranch.sh`, `prbranch.sh`, and `rmbranch.sh` in the root directory of your Git repository (or in a directory included in your system's `PATH`).
2.  **Make them executable:**
    ```bash
    chmod +x mkbranch.sh prbranch.sh rmbranch.sh
    ```

**Note:** Each script assumes your default main branch is named `main`. If your main branch is named `master` or something else, you can pass its name as an optional last argument to the scripts.

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