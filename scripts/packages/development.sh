#!/bin/bash

################################################################################
# Development Tools Installation Script
#
# Description: Installs development tools, compilers, and programming languages
################################################################################

set -e

echo "Installing development tools..."

# Update package lists
apt-get update -qq

# Install build essentials and compilers
echo "Installing build tools and compilers..."
apt-get install -y \
    build-essential \
    gcc \
    g++ \
    gdb \
    make \
    cmake \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libssl-dev \
    libffi-dev \
    libreadline-dev \
    zlib1g-dev \
    libbz2-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libgdbm-dev \
    liblzma-dev \
    tk-dev

# Install Python and tools
echo "Installing Python and related tools..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python-is-python3

# Install Node.js via NodeSource (LTS version)
echo "Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs
fi

# Install Go (if not already installed)
echo "Installing Go..."
if ! command -v go &> /dev/null; then
    GO_VERSION="1.21.5"
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    rm -rf /usr/local/go
    tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    
    # Add Go to PATH for all users
    if ! grep -q "/usr/local/go/bin" /etc/environment; then
        echo 'PATH="/usr/local/go/bin:$PATH"' >> /etc/environment
    fi
fi

# Install Rust (via rustup for current user)
echo "Rust can be installed per-user with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

# Install version control and related tools
echo "Installing version control tools..."
apt-get install -y \
    git \
    git-lfs \
    tig

# Install additional development tools
echo "Installing additional development utilities..."
apt-get install -y \
    silversearcher-ag \
    ripgrep \
    fd-find \
    bat \
    shellcheck \
    yamllint

echo "Development tools installed successfully"
echo ""
echo "Note: Some tools may require shell restart or sourcing environment files"
echo "  - Go: Add /usr/local/go/bin to PATH"
echo "  - Rust: Install with 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh'"
