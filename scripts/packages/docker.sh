#!/bin/bash

################################################################################
# Docker Installation Script
#
# Description: Installs Docker Engine, Docker Compose, and related tools
################################################################################

set -e

echo "Installing Docker..."

# Remove old versions
echo "Removing old Docker versions..."
apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Install prerequisites
echo "Installing prerequisites..."
apt-get update -qq
apt-get install -y \
    ca-certificates \
    curl \
    gnupg

# Add Docker's official GPG key
echo "Adding Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "Installing Docker Engine..."
apt-get update -qq
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Enable and start Docker
echo "Enabling Docker service..."
systemctl enable docker
systemctl start docker

# Add current user to docker group if not root
if [[ -n "${SUDO_USER:-}" ]]; then
    echo "Adding user $SUDO_USER to docker group..."
    usermod -aG docker "$SUDO_USER"
    echo "Note: User $SUDO_USER needs to log out and back in for docker group changes to take effect"
fi

# Verify installation
echo "Verifying Docker installation..."
docker --version
docker compose version

echo "Docker installed successfully!"
echo ""
echo "Post-installation steps:"
echo "  - Log out and back in for group changes to take effect"
echo "  - Test with: docker run hello-world"
