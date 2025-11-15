#!/bin/bash

################################################################################
# Essential Packages Installation Script
#
# Description: Installs essential system utilities and tools
################################################################################

set -e

echo "Installing essential packages..."

# Update package lists
apt-get update -qq

# Install essential utilities
apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    btop \
    tmux \
    screen \
    tree \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    jq \
    yq \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    net-tools \
    iputils-ping \
    dnsutils \
    traceroute \
    netcat-openbsd \
    openssh-client \
    rsync \
    less \
    man-db \
    bash-completion \
    sudo

echo "Essential packages installed successfully"
