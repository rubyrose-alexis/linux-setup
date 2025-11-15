#!/bin/bash
#
# Example user-data script for cloud VM initialization
# This script can be used as user-data/startup script for:
#   - AWS EC2 instances
#   - Google Cloud Compute Engine instances
#   - Azure Virtual Machines
#   - DigitalOcean Droplets
#
# Usage: Copy this script content to your cloud provider's user-data field
#        when creating a new VM instance

# Exit on error
set -e

# Log output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting linux-setup installation..."
echo "Date: $(date)"

# Update system
apt-get update -y
apt-get install -y git

# Clone the repository
cd /opt
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup

# Run installation
# Choose one of the following options:

# Option 1: Full installation (recommended for development)
./install.sh --full

# Option 2: Minimal installation (for production servers)
# ./install.sh --minimal

# Option 3: Docker only
# ./install.sh --docker

# Option 4: Development tools only
# ./install.sh --dev

# Optional: Install cloud tools separately
# bash scripts/packages/cloud-tools.sh

# Copy to default user's home directory
if [ -d /home/ubuntu ]; then
    cp -r /opt/linux-setup /home/ubuntu/
    chown -R ubuntu:ubuntu /home/ubuntu/linux-setup
fi

echo "Linux setup completed successfully!"
echo "Installation log: /var/log/user-data.log"
