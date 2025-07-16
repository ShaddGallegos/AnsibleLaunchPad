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

### Step 3 - Install ansible-navigator and ancillary dev tools
We have installed ansible-core and executed a simple ad-hoc command and playbook. We are now ready to install the rest of the development environment and start writing our 
ansible playbooks. 

By installing ansible-navigator we will install the majority of all development tools automatically. Installing ansible-navigator is pretty straightforward but for a comprehensive
guide please see the docs [here](https://ansible.readthedocs.io/projects/navigator/).

To install ansible-navigator:
```bash
$ pip install ansible-navigator
```
To see se packages were installed:
```bash
$ pip list | grep ansible
ansible-builder           3.1.0
ansible-compat            24.10.0
ansible-core              2.15.13
ansible-lint              6.22.2
ansible-navigator         24.2.0
ansible-runner            2.4.1

Lets test ansible-navigator with our super simple playbook:
```bash
$ ansible-navigator run hello.yaml --ee false --mode stdout

PLAY [A super simple playbook] *************************************************

TASK [Display a message to the screen] *****************************************
ok: [localhost] => {
    "msg": "Ansible is really cool!"
}

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

In this case we ran ansible-navigator in "local" mode. Ansible now makes use of execution environments so we need to prep our system to use containers. Podman is the preferred container
runtime but docker can be used if preferred.

To install podman:
```bash
$ sudo yum install podman
$ podman --version
```

Now we have a bare bones installation of ansible-navigator and all the dev tools. We can test our super simple playbook with a container execution environment this time. 
```bash
$ ansible-navigator run hello.yaml --mode stdout
```

What happened here? We spun up a container (execution-environment) that ran the automation, meaning we decoupled the automation from your laptop to a container. This allows for more
consistent development and minimizes the WIWOMM effext ("Well it works on my machine";-).

You can also spin up ansible-navigator in the tui interface by simply running:
```bash
$ ansible-navigator
```
Here you can poke around the ansible environment




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
