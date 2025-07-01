# README.md

### Document: Explanation of the Scripts and How to Use Them

#### Overview
This document explains the purpose and functionality of the provided scripts for setting up a Red Hat Enterprise Linux (RHEL) 9.6 environment on Windows Subsystem for Linux (WSL). It also describes how to run these scripts from the Windows host system, accessible via `/c/Users/<username>/Downloads` in WSL.

---
### Creating a Microsoft WSL Image RHEL 9.6

#### The Manual Part

https://console.redhat.com/insights/image-builder
select Preview Mode 
create a blueprint

CHOOSE: 
Release:
    RHEL 9
Architecture:
    x86_64
Select target environments:
    "Other"
"WSL - Windows Subsystem for Linux (.tar.gz)"
Next

CHOOSE:
Registration method:
    Register later
Review and finish

NOTE: This button has a dropdown
CHOOSE:
Create blueprint and build images

That will take you to 
Image build in progress

Once the build finishes you can download the RHEL9-x86_64.tar.gz file to your windows machine.

### Script 1: PowerShell Script for WSL Setup

#### Purpose
The PowerShell script automates the process of:
1. Installing 7-Zip if not already installed.
2. Extracting the RHEL `.tar.gz` file to a `.tar` file.
3. Enabling WSL and required Windows features.
4. Importing the extracted RHEL `.tar` file into WSL.

#### How It Works
1. **7-Zip Installation**:
   - Checks if 7-Zip is installed by verifying the existence of its executable.
   - If not installed, downloads the latest 7-Zip MSI installer and installs it silently.

2. **Extracting `.tar.gz` File**:
   - Uses 7-Zip to extract the `.tar.gz` file into a `.tar` file.

3. **Enabling WSL Features**:
   - Enables the `Microsoft-Windows-Subsystem-Linux` and `VirtualMachinePlatform` features using `dism.exe`.

4. **Updating and Configuring WSL**:
   - Updates WSL to the latest version.
   - Sets WSL 2 as the default version.
   - Imports the extracted `.tar` file into WSL, creating a new RHEL instance.

#### How to Use
1. Place the RHEL `.tar.gz` file in your `Downloads` folder on Windows.
2. Open PowerShell as Administrator.
3. Navigate to the script's location (e.g., `cd C:\Users\<username>\Downloads`).
4. Run the script: `.\<script-name>.ps1`.

---

### Script 2: Bash Script for RHEL Configuration in WSL

#### Purpose
The Bash script configures the RHEL environment inside WSL by:
1. Registering the system with Red Hat.
2. Setting up a root password and creating a WSL user.
3. Installing essential packages and Ansible development tools.
4. Granting the WSL user administrative privileges.

#### How It Works
1. **Prompting for Input**:
   - Prompts the user for Red Hat credentials, WSL username, and passwords.

2. **Registering with Red Hat**:
   - Uses `subscription-manager` to register the system with Red Hat and attach a subscription.

3. **Setting Up Users**:
   - Sets a root password.
   - Creates a new WSL user and sets their password.
   - Generates an SSH key for the WSL user and copies it to localhost for SSH access.

4. **Installing Packages**:
   - Upgrades system packages using `dnf`.
   - Installs essential tools like `python3-pip`, `podman`, `git`, and others.

5. **Setting Up Ansible Development Tools**:
   - Upgrades `pip` and installs various Ansible-related tools for development.

6. **Granting Administrative Privileges**:
   - Adds the WSL user to the `sudoers` file with passwordless sudo access.
   - Adds the user to necessary system groups for administrative tasks.

#### How to Use
1. Place the script in your `Downloads` folder on Windows.
2. Open WSL and navigate to the `Downloads` folder:  
   `cd /c/Users/<username>/Downloads`.
3. Make the script executable:  
   `chmod +x <script-name>.sh`.
4. Run the script:  
   `sudo ./<script-name>.sh`.

---

### Accessing the Host System from WSL
WSL provides seamless access to the Windows file system. The Windows `C:\` drive is mounted under `/c/` in WSL. For example:
- The `Downloads` folder for the current user is accessible at `/c/Users/<username>/Downloads`.

This allows you to place the scripts and required files (e.g., the RHEL `.tar.gz` file) in the `Downloads` folder on Windows and access them directly from WSL.

---

### Notes
- Ensure you run the PowerShell script as an Administrator.
- The Bash script requires `sudo` privileges to execute system-level commands.
- Replace `<username>` with your actual Windows username when navigating paths.

By following these steps, you can set up and configure a RHEL environment on WSL efficiently.