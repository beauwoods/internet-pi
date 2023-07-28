#!/bin/bash

# This script is designed to automate the configuration process of the Internet Pi project found at:
# https://github.com/beauwoods/internet-pi
# The project is a Raspberry Pi configuration for Internet connectivity, which includes features like Internet monitoring, 
# Pi-hole for network-wide ad-blocking and local DNS, and other optional features like Shelly Plug Monitoring, 
# AirGradient Monitoring, and Starlink Monitoring.

# The script will guide the user through the configuration process, asking for each configuration option and adding the chosen
# options to a new `config.yml` file.

# Initialize an empty config.yml
# The `config.yml` file will hold all the configuration options chosen by the user
echo "---" > config.yml

# Ask the user for the location where configuration files will be stored
# The location can be any directory on the system where the user has write permissions
read -p "Enter the location where configuration files will be stored (default: '~'): " config_dir
echo "config_dir: '${config_dir:-~}'" >> config.yml

# Ask the user if they want to enable domain names configuration
# If enabled, the user can access the services via domain names instead of IP addresses
read -p "Do you want to enable domain names for the local network? (y/n): " domain_name_enable
if [[ "$domain_name_enable" == "y" ]]; then
  echo "domain_name_enable: true" >> config.yml
  read -p "Enter the domain name (default: 'home.local'): " domain_name
  echo "domain_name: '${domain_name:-home.local}'" >> config.yml
else
  echo "domain_name_enable: false" >> config.yml
fi

# Ask the user which hosts to monitor for internet monitoring
echo "Enter the hosts you want to monitor, in the format 'URL;Human-readable name'."
echo "For example, 'https://google.com;Google'."
echo "These should be hosts that your network accesses frequently and you want to keep track of."
echo "Enter one host per line, and an empty line when you're done."

monitoring_ping_hosts=()
while true; do
  read -p "Host: " host
  if [[ -z "$host" ]]; then
    break
  else
    monitoring_ping_hosts+=("$host")
  fi
done

echo "monitoring_ping_hosts:" >> config.yml
for host in "${monitoring_ping_hosts[@]}"; do
  echo "  - $host" >> config.yml
done


# Ask the user if they want to install Pi-hole
# Pi-hole is a network-wide ad blocker that also provides local DNS services
read -p "Do you want to install Pi-hole? (y/n): " pihole_enable
if [[ "$pihole_enable" == "y" ]]; then
  echo "pihole_enable: true" >> config.yml
  read -p "Enter the Pi-hole hostname (default: 'pihole'): " pihole_hostname
  echo "pihole_hostname: '${pihole_hostname:-pihole}'" >> config.yml
  
  # Check if the `timedatectl` command is available
  if command -v timedatectl &> /dev/null; then
    # Get a list of continents
    continents=$(timedatectl list-timezones | cut -d "/" -f1 | uniq)

    # Ask the user to select a continent
    echo "Select a continent:"
    select continent in $continents; do
      if [[ -n "$continent" ]]; then
        echo "You selected: $continent"
        break
      else
        echo "Invalid selection"
      fi
    done

    # Get a list of timezones for the selected continent
    timezones=$(timedatectl list-timezones | grep "^$continent/")

    # Ask the user to select a timezone
    echo "Select a timezone:"
    select pihole_timezone in $timezones; do
      if [[ -n "$pihole_timezone" ]]; then
        echo "You selected: $pihole_timezone"
        break
      else
        echo "Invalid selection"
      fi
    done
  else
    # If `timedatectl` is not available, use the current system timezone
    echo "The \`timedatectl\` command is not available. Using the current system timezone."
    pihole_timezone=$(date +%Z)
  fi

  echo "pihole_timezone: '${pihole_timezone}'" >> config.yml
  read -p "Enter the Pi-hole password (default: 'change-this-password'): " pihole_password
  echo "pihole_password: '${pihole_password:-change-this-password}'" >> config.yml
else
  echo "pihole_enable: false" >> config.yml
fi

# Continue with the rest of the configurations...

echo "Configuration completed successfully!"

# For more information about the project and the configuration options, please visit the GitHub repo at:
# https://github.com/beauwoods/internet-pi
