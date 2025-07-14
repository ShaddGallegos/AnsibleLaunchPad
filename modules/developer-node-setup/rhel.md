# RHEL Developer Node Setup
--------------------

<img src="images/developer-node.png" alt="final image" width="400" height="400">

A comprehensive guide for configuring and validating a RHEL development environment to work with Ansible Automation Platform. This is a guide to get you up and running quickly. For a comprehensive guide please see the official documentation [here](https://docs.ansible.com/ansible-core/devel/installation_guide/index.html)

## Assumptions
- A relatively current x86_64 laptop running at least RHEL 7 or Fedora
- An internet connection
- Access to repositories (RPM or PIP)
- A valid login to registry.redhat.io to pull execution environments

### Step 1
Install ansible-core, which is the minimal package needed to run Ansible playbooks and ad-hoc commands - Many Linux distributions will come pre loaded with ansible-core to check, execute the "ansible --version" command at a prompt, if the command is not found then we will need to install ansble-core. Installing ansible-core will automatically install all needed dependencies to include all Python and system packages needed for Ansible to function at a minimal level. The easiest way to install ansible-core is through pip (python package manager)

Ensure pip is available: 
```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
```
Install ansible-core
```bash
pip install --user ansible
```

### Step 2 
Validate the installation by running a couple of ansible commands

ansible --version will show the current package used by the system. This command will also display the python versions and ancillary directories.
```bash
[user@controller-vm ~]$ ansible --version
ansible [core 2.15.13]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/user/.local/lib/python3.9/site-packages/ansible
  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.9.18 (main, Jul  3 2024, 00:00:00) [GCC 11.4.1 20231218 (Red Hat 11.4.1-3)] (/usr/bin/python3)
  jinja version = 3.1.6
  libyaml = True
```

Run an Ansible ad-hoc command. In this case we are invoking the setup module which returns all the relavant information on the current system
```bash
ansible localhost -m setup
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.124.157"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::5054:ff:fe04:7fb0"
        ],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "04/01/2014",
        "ansible_bios_vendor": "SeaBIOS",
        "ansible_bios_version": "1.16.3-2.fc40",
        "ansible_board_asset_tag": "NA",
        "ansible_board_name": "NA",
```

If everything comes back green... Congrats! You have ran your first Ansible command and you are ready to start Automating!

### Step 2 Bonus - Run a super simple playbook.
Copy the following code block and save to a file on your machine such as hello.yaml. Make sure all spacing and indentation is preserved.
```bash
---
- name: A super simple playbook
  hosts: localhost
  gather_facts: false

  tasks:

    - name: Display a message to the screen
      ansible.builtin.debug:
        msg: Ansible is really cool!
```

Run the ansible-playbook command to process the playbook
```bash
ansible-playbook hello.yaml 

PLAY [A super simple playbook] *************************************************************************************************************************************************

TASK [Display a message to the screen] *****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ansible is really cool!"
}

PLAY RECAP *********************************************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

If everything is configured correctly and working, the Ansible playbook is processed and a message is displayed on the screen. 

You should now have a minimal Ansible development environment. In the next step we will add on to our environment with other tools. 



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
