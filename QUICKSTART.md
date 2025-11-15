# Quick Start Guide

This guide will help you get started with linux-setup in different scenarios.

## Scenario 1: New Cloud VM Setup

You've just created a fresh Ubuntu 24.04 VM and want to set it up quickly.

```bash
# SSH into your VM
ssh user@your-vm-ip

# Clone the repository
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup

# Run full installation (recommended for development VMs)
sudo ./install.sh

# Restart your shell or source bashrc
source ~/.bashrc

# Verify installation
bash scripts/utils/system-info.sh
```

## Scenario 2: Minimal Server Setup

You need a lightweight setup for a production server.

```bash
# Clone and navigate
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup

# Install only essential packages
sudo ./install.sh --minimal

# Source the new configuration
source ~/.bashrc
```

## Scenario 3: Docker Development Environment

You want to use Docker for containerized development.

```bash
# On your local machine or VM
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup

# Build the Docker image
docker build -t ubuntu-devenv:latest .

# Run with your code mounted
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.aws:/root/.aws:ro \
  ubuntu-devenv:latest

# Or use docker-compose
docker-compose up -d
docker-compose exec devenv bash
```

## Scenario 4: Python Development Setup

Setting up for Python development.

```bash
# Run installation with dev tools
sudo ./install.sh --dev

# Create a Python project
mkdir ~/projects/myapp
cd ~/projects/myapp

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install packages
pip install flask requests
```

## Scenario 5: Adding Cloud Tools Later

You initially did a minimal install and now need cloud CLI tools.

```bash
cd linux-setup

# Install cloud tools
sudo bash scripts/packages/cloud-tools.sh

# Configure AWS
aws configure

# Verify
aws --version
gcloud --version
az --version
kubectl version --client
```

## Scenario 6: Docker-Only Setup

You only need Docker and container tools.

```bash
# Clone repository
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup

# Install Docker
sudo ./install.sh --docker

# Log out and back in, or run:
newgrp docker

# Test Docker
docker run hello-world
```

## Scenario 7: Multiple VMs with Same Configuration

You need to set up multiple VMs identically.

```bash
# On your first VM, customize the scripts as needed
cd linux-setup
# Edit scripts/config/environment.sh for custom aliases
# Edit scripts/packages/*.sh for custom packages

# Commit your changes to a fork or branch
git add .
git commit -m "Custom configuration"
git push

# On other VMs
git clone https://github.com/your-username/linux-setup.git
cd linux-setup
sudo ./install.sh
```

## Scenario 8: Using as a Bootstrap Script

Automate VM creation with user-data or cloud-init.

**AWS EC2 User Data:**
```bash
#!/bin/bash
apt-get update
apt-get install -y git
git clone https://github.com/rubyrose-alexis/linux-setup.git /opt/linux-setup
cd /opt/linux-setup
./install.sh --full
```

**Cloud-Init YAML:**
```yaml
#cloud-config
package_update: true
packages:
  - git

runcmd:
  - git clone https://github.com/rubyrose-alexis/linux-setup.git /opt/linux-setup
  - cd /opt/linux-setup && ./install.sh --full
```

## Scenario 9: Keeping Your Setup Updated

Regular maintenance of your VM.

```bash
# Update system packages
sudo bash scripts/utils/update-system.sh

# Or pull latest changes from linux-setup
cd linux-setup
git pull origin main

# Re-run specific scripts if needed
sudo bash scripts/packages/development.sh
```

## Scenario 10: Creating a Custom Image

Create a reusable VM image or AMI.

```bash
# Set up a base VM
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup
sudo ./install.sh --full

# Clean up before imaging
sudo apt-get clean
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
history -c

# Create image using your cloud provider's tools
# AWS: Create AMI from instance
# GCP: Create image from disk
# Azure: Capture VM image
```

## Common Post-Installation Tasks

### Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Set Up SSH Keys
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add to GitHub, GitLab, etc.
```

### Configure AWS CLI
```bash
aws configure
# Enter: Access Key ID, Secret Access Key, Region, Output format
```

### Install Additional Python Packages
```bash
pip3 install --user numpy pandas matplotlib jupyter
```

### Set Up Docker Compose Project
```bash
mkdir ~/projects/myapp
cd ~/projects/myapp
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
EOF
docker compose up -d
```

## Troubleshooting

### Script fails with "permission denied"
```bash
# Make sure you're using sudo
sudo ./install.sh

# Or make scripts executable
chmod +x install.sh
chmod +x scripts/**/*.sh
```

### Docker permission denied after installation
```bash
# Log out and back in, or run:
newgrp docker

# Verify you're in docker group
groups
```

### Command not found after installation
```bash
# Source your bashrc
source ~/.bashrc

# Or check PATH
echo $PATH

# Manually add to PATH
export PATH="/usr/local/go/bin:$PATH"
```

### Package installation fails
```bash
# Update package lists
sudo apt-get update

# Check for held packages
sudo apt-mark showhold

# Check disk space
df -h
```

## Tips and Best Practices

1. **Always backup before major changes**
   ```bash
   cp ~/.bashrc ~/.bashrc.backup
   ```

2. **Test in a snapshot or staging environment first**

3. **Keep the linux-setup repository for future updates**

4. **Document any custom modifications**

5. **Use version control for your configuration files**

6. **Regularly update packages**
   ```bash
   sudo bash scripts/utils/update-system.sh
   ```

7. **Monitor disk space on VMs**
   ```bash
   df -h
   du -sh ~/
   ```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [PACKAGES.md](PACKAGES.md) for complete package list
- Customize scripts in `scripts/` directory for your needs
- Star the repository if you find it useful!
