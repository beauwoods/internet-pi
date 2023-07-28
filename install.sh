#!/bin/bash

# This script is designed to automate the installation process of the Internet Pi project found at:
# https://github.com/beauwoods/internet-pi
# The project is a Raspberry Pi configuration for Internet connectivity, which includes features like Internet monitoring, 
# Pi-hole for network-wide ad-blocking and local DNS, and other optional features like Shelly Plug Monitoring, 
# AirGradient Monitoring, and Starlink Monitoring.

# Halt if any errors happen to avoid having a half-broken install
set -e

# Install necessary dependencies
# The project requires git to clone the repository and Ansible to run the playbook
echo "Installing necessary dependencies..."
apt-get update && \
apt-get install -y git ansible docker 1> /dev/null

# Clone the GitHub repo
# The project's code is hosted on GitHub, so we clone the repo to get the code
echo "Cloning the GitHub repo..."
git clone https://github.com/beauwoods/internet-pi.git 1> /dev/null

# Change directory to the cloned repo
# The Ansible playbook is located in the root of the repo, so we change directory to the repo
cd internet-pi 1> /dev/null

# Run the configuration script so we can create a custom version of the config.yml
echo "Running the configuration script, based on the example config in the repository." 
chmod +x configure.sh
bash configure.sh

# Copy the example inventory to the usable inventory
cp example.inventory.ini inventory.ini

# Run the Ansible playbook
# The playbook automates the configuration of the Raspberry Pi according to the project's specifications
echo "Running the Ansible playbook..."
ansible-playbook main.yml

# Check if the playbook run was successful
# If the playbook run fails, we stop the script and notify the user
if [[ $? -ne 0 ]]; then
   echo "The Ansible playbook run failed. Please check the output for errors."
   exit 1
fi

echo "Installation completed successfully!"
# If the playbook run is successful, we notify the user that the installation is complete


# For more information about the project, please visit the GitHub repo at:
# https://github.com/beauwoods/internet-pi
