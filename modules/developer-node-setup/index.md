# Developer Node Setup
--------------------

![Developer Node Setup](images/developer-node-setup.png)

This document provides a guide on setting up various developer nodes for 
using Ansible and other Red Hat tools. The options include:

1. **Linux System Hardware**
2. **Linux System VM:** For more information, please refer to the 
[script](<https://github.com/ShaddGallegos/Base_EE-DE_Builder>).
3. **Windows**:
    - Create an RHEL 9.6 WSL by following these steps: 
<https://console.redhat.com/insights/image-builder>
    - For more information on the script, please refer to [this 
link](<https://github.com/ShaddGallegos/Base_EE-DE_Builder>).
4. **Virtual Machine**:
    - Create an RHEL 9.6 QCOW2 image using Red Hat's Image Builder 
service: <https://console.redhat.com/insights/image-builder>
5. **Container**:
    - Pull the latest `ansible-dev-tools-rhel8` image from Red Hat's container registry:
        ```bash
        podman pull registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:lregistry.redhat.io/ansible-automation-platform-25/ansibe-dev-tools-rhel8:latest
        ```
    - If you are using Docker, use the same command:
        ```bash
        docker pull registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:lregistry.redhat.io/ansible-automation-platform-25/ansibe-dev-tools-rhel8:latest
        ```
    - Import the image into OpenShift (oc) and confirm the installation:
        ```bash
        oc import-image ansible-automation-platform-25/ansible-dev-tools-rhel8:25.2.0-48 --from=registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools---from=regstry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:latest --confirm
        ```
    - Install Visual Studio Code using the following steps:
        1. Import the Red Hat's GPG key: `sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc`
        2. Create a new repository file:
            ```bash
            sudo sh -c 'curl -sSL https://packages.microsoft.com/config/rhel/9/prod.repo -o /etc/yum.repos.d/vscode.repo'
            ```
        3. Check for updates and install Visual Studio Code:
            ```bash
            sudo dnf check-update && sudo dnf install code
            ```
6. **Updating Images**: For more information, please refer to the [repository](<https://github.com/ShaddGallegos/Base_EE-DE_Builder>).
7. **Documentation**:
    - Red Hat's Automation Good Practices Guide: 
<https://github.com/redhat-cop/automation-good-practices>
    - Ansible slides: <https://ansible.github.io/slides/>
    - Awesome Ansible repository: 
<https://github.com/ansible-community/awesome-ansible>
8. **Where to get the code**: You can find the code for this project at 
[GitHub](<https://github.com/aoyawale/ansible-devspaces-demo>)
