# RHEL Developer Node Setup
--------------------

<img src="images/developer-node.png" alt="final image" width="400" height="400">

A comprehensive guide for configuring and validating a RHEL development environment to work with Ansible Automation Platform.

## Assumptions
- A relatively current x86_64 laptop running at least RHEL 7 or Fedora
- An internet connection
- Access to repositories (RPM or PIP)
- A valid login to registry.redhat.io to pull execution environments

### Step 1
- Install ansible-core
Many Linux distributions will come pre loaded with ansible-core to check, execute the "ansible --version" command at a prompt, if the command is not found then we will need to install ansble-core.  


## Table of Contents

- [Configuration](#configuration)
- [Ansible Developer Nodes](#ansible-developer-nodes)
- [Development Environment Setup](#development-environment-setup)
- [Documentation](#documentation)
- [Code Examples and Resources](#code-examples-and-resources)

## Configuration

### Configure ansible.cfg

Create or update your `/etc/ansible/ansible.cfg` file with API tokens for both Automation Hub and Ansible Galaxy:

```ini
[galaxy]
server_list = automation_hub, ansible-galaxy

[galaxy_server.automation_hub]
url=https://cloud.redhat.com/api/automation-hub/ 
auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
token=<YOUR CONSOLE.REDHAT.COM TOKEN HERE>

[galaxy_server.ansible-galaxy]
url=https://galaxy.ansible.com/
token=<YOUR GALAXY TOKEN HERE>
```

## What is an Ansible Developer Node?

An **Ansible Developer Node** is a development environment where you can write, test, and debug Ansible playbooks and automation content. It can be set up in various ways depending on your infrastructure and preferences.

## Ansible Developer Nodes

You can set up an Ansible Developer Node using any of the following options:

### 1. Linux System Hardware
Physical Linux system with Ansible installed directly. See installation script for setup details.

### 2. Linux System VM
Create a RHEL 9.6 QCOW2 image using Red Hat's Image Builder:
- Visit: https://console.redhat.com/insights/image-builder
- See setup script for detailed configuration

### 3. Windows with WSL
Run RHEL 9.6 in Windows Subsystem for Linux:
- Create RHEL 9.6 WSL image: https://console.redhat.com/insights/image-builder
- See setup script for installation steps

### 4. Linux Container
Use the official Red Hat Ansible Developer Tools container:

```bash
# Using Podman
podman pull registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:latest

# Using Docker
docker pull registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:latest

# Using OpenShift
oc import-image ansible-automation-platform-25/ansible-dev-tools-rhel8:25.2.0-48 \
  --from=registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:latest \
  --confirm
```

## Development Environment Setup

### Updating DE/EE Images

For building and maintaining Development Environment (DE) and Execution Environment (EE) images:

```bash
git clone https://github.com/ShaddGallegos/Base_EE-DE_Builder
cd Base_EE-DE_Builder
# See README.md for detailed instructions
```

### Installing VS Code on RHEL

```bash
# Import Microsoft GPG key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add VS Code repository
sudo sh -c 'curl -ssl https://packages.microsoft.com/config/rhel/9/prod.repo -o /etc/yum.repos.d/vscode.repo'

# Install VS Code
sudo dnf check-update && sudo dnf install code
```

## Documentation

Essential documentation and learning resources:

- [Red Hat CoP Automation Good Practices](https://github.com/redhat-cop/automation-good-practices)
- [Ansible Slides and Presentations](https://ansible.github.io/slides/)
- [Awesome Ansible Community Resources](https://github.com/ansible-community/awesome-ansible)

## Code Examples and Resources

### Getting Started

- [Ansible DevSpaces Demo](https://github.com/aoyawale/ansible-devspaces-demo)

### Comprehensive Code Examples

#### General Red Hat Resources
- [Red Hat CoP](https://github.com/redhat-cop) - Everything Red Hat
- [Red Hat Government Demos](https://github.com/RedHatGov/product-demos/tree/sat) - Satellite Playbooks
- [Red Hat Satellite](https://github.com/RedHatSatellite) - Satellite Playbooks
- [Red Hat NASA](https://github.com/orgs/RedHatNASA/repositories) - Quick setup demos
- [Ansible Workshops](https://github.com/ansible/workshops/tree/main) - Workshop environments
- [JJ Aswanson Examples](https://github.com/jjaswanson4?tab=repositories) - Various examples

#### Windows Automation
- [oatakan Windows Playbooks](https://github.com/oatakan)
- [Microsoft WUFB Reports](https://github.com/microsoft/wufb-reports-access-control)
- [Microsoft Ansible Labs](https://github.com/microsoft/AnsibleLabs)
- [Windows Demo Playbooks](https://github.com/nickarellano/ansible-windows-demo)

#### CI/CD and Containers
- [CI/CD Playbooks](https://github.com/p-avery/cicd-playbooks)
- [EE/DE Examples](https://github.com/cloin/ee-builds)
- [Automated EE/DE Examples](https://github.com/nickarellano/ee-containers)
- [Automated EE Creation](https://github.com/ShaddGallegos/ee-containers)

#### Specialized Use Cases
- [Linux Academy Admin Examples](https://github.com/linuxacademy/content-ansible-playbooks)
- [SAP Automation](https://github.com/sap-linuxlab)
- [Network Management](https://github.com/zjleblanc/ansible-network-mgmt/tree/master)
- [Cisco Network Demos](https://github.com/zjleblanc/ansible-cisco-demos)
- [Network Automation](https://github.com/nleiva/ansible-networking)

#### Security and Compliance
- [OpenSCAP](https://github.com/OpenSCAP)
- [CISA Government](https://github.com/cisagov)
- [Security Compliance](https://github.com/Ansible-Security-Compliance)

#### Advanced Topics
- [Dynamic Survey AAP](https://github.com/joebrown-RH/Dynamic_Survey_AAP) - Alternative Dynamic Inventory
- [ServiceNow/EDA](https://github.com/ericcames) - ServiceNow and Event-Driven Ansible

---

## Contributing

Feel free to contribute to this guide by submitting pull requests or opening issues for any corrections or additions.

## License

This documentation is provided as-is for educational and reference purposes.
