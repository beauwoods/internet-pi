#!/bin/bash

# This script is designed to automate the installation process of the Internet Pi project found at:
# https://github.com/beauwoods/internet-pi
# The project is a Raspberry Pi configuration for Internet connectivity, which includes features like Internet monitoring, 
# Pi-hole for network-wide ad-blocking and local DNS, and other optional features like Shelly Plug Monitoring, 
# AirGradient Monitoring, and Starlink Monitoring.

# Install necessary dependencies
# The project requires git to clone the repository and Ansible to run the playbook
echo "Installing necessary dependencies..."
apt-get update
apt-get install -y git ansible

# Clone the GitHub repo
# The project's code is hosted on GitHub, so we clone the repo to get the code
echo "Cloning the GitHub repo..."
git clone https://github.com/beauwoods/internet-pi.git

# Change directory to the cloned repo
# The Ansible playbook is located in the root of the repo, so we change directory to the repo
cd internet-pi

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

# Ask the user if they want to run the configuration script
read -p "Do you want to run the configuration script now? (y/n): " run_config
if [[ "$run_config" == "y" ]]; then
  # Run the configuration script
  bash configure.sh
else
  echo "You can run the configuration script later by running 'bash configure.sh'"
fi

# For more information about the project, please visit the GitHub repo at:
# https://github.com/beauwoods/internet-pi
