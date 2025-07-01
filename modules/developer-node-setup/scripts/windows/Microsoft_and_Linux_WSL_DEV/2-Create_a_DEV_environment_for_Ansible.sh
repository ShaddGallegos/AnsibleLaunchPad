# Create_a_DEV_environment_for_Ansible_development.sh
# Script 2 (Bash)
# This script is designed to be run inside the WSL environment after importing RHEL9.
# It registers the system with Red Hat, sets up a user, and installs essential packages.
# Ensure you have the necessary permissions to run this script.
# This script requires root privileges to run successfully.
# Run as root or with sudo
# Define variables
#RH_USERNAME=""
#RH_PASSWORD=""
#WSL_USER=""
#WSL_PASSWORD=""
# Define the path to the SSH key
#SSH_KEY_PATH="/home/$WSL_USER/.ssh/id_rsa"
# Define the path to the SSH public key
#SSH_PUBLIC_KEY_PATH="/home/$WSL_USER/.ssh/id_rsa.pub"
# Define the path to the SSH config file
#SSH_CONFIG_PATH="/home/$WSL_USER/.ssh/config"
# Define the path to the SSH known hosts file
#SSH_KNOWN_HOSTS_PATH="/home/$WSL_USER/.ssh/known_hosts"
# Define the path to the sudoers file
#SUDOERS_FILE="/etc/sudoers"
# Define the path to the WSL user home directory
#!/bin/bash

# Function to prompt for input
prompt_input() {
    read -p "Enter your $1: " "$2"
}

# Function to securely prompt for passwords
prompt_password() {
    read -s -p "Enter your $1: " "$2"
    echo ""
}

# Step 1 & 2: Collect Red Hat credentials
prompt_input "Red Hat username" RH_USERNAME
prompt_password "Red Hat password" RH_PASSWORD

# Step 3: Register system with Red Hat
echo "Registering system with Red Hat..."
subscription-manager register --auto-attach --username "$RH_USERNAME" --password "$RH_PASSWORD"
subscription-manager status || { echo "Registration failed! Exiting."; exit 1; }

# Step 4: Set up root password
echo "Setting up root password..."
passwd root

# Step 5 & 6: Create a WSL user
prompt_input "WSL username" WSL_USER
useradd -m -s /bin/bash "$WSL_USER"
prompt_password "password for $WSL_USER" WSL_PASSWORD
echo "$WSL_USER:$WSL_PASSWORD" | chpasswd

# Step 7: Generate SSH key quietly for WSL user
echo "Generating SSH key for $WSL_USER..."
su - "$WSL_USER" -c "ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa"

# Step 8: Copy SSH key to localhost
echo "Copying SSH key to localhost..."
su - "$WSL_USER" -c "ssh-copy-id -i ~/.ssh/id_rsa.pub $WSL_USER@localhost"

# Step 9: Upgrade system packages
echo "Upgrading system..."
dnf upgrade -y

# Step 10: Install essential packages efficiently
echo "Installing packages..."
dnf install -y python3-pip podman podman-docker git || { echo "Package installation failed!"; exit 1; }

# Step 11 & 12: Upgrade pip and install Ansible Dev Tools
echo "Setting up Ansible development environment..."
su - "$WSL_USER" -c "pip3 install --upgrade pip && pip install --upgrade ansible-core ansible-builder ansible-creator ansible-lint ansible-navigator ansible-sign molecule pytest-ansible tox-ansible ansible-dev-environment"

# Step 13: Grant sudo privileges to WSL user
echo "Granting sudo privileges to $WSL_USER..."
echo "$WSL_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Step 14: Add WSL user to system administrator groups
echo "Adding $WSL_USER to necessary groups..."
usermod -aG wheel,libvirt,kvm,qemu,docker,adm,systemd-journal "$WSL_USER"

echo "Setup complete! Everything is configured successfully."
#End of script2