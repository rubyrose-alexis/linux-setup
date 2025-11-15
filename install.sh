#!/bin/bash

################################################################################
# Linux Setup - Main Installation Script
# 
# Description: Automated setup script for Ubuntu 24.04.3 LTS cloud VMs
# Usage: ./install.sh [OPTIONS]
# Options:
#   --minimal     Install only essential packages
#   --full        Install all packages including development tools
#   --docker      Install Docker and container tools
#   --dev         Install development tools only
#   --help        Display this help message
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Log file
readonly LOG_FILE="/tmp/linux-setup-$(date +%Y%m%d-%H%M%S).log"

################################################################################
# Helper Functions
################################################################################

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $*" | tee -a "$LOG_FILE" >&2
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $*" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $*" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root or with sudo"
        exit 1
    fi
}

check_ubuntu() {
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot detect OS version"
        exit 1
    fi
    
    source /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        log_warning "This script is designed for Ubuntu. Current OS: $ID"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    log_info "Detected OS: $PRETTY_NAME"
}

display_help() {
    cat << EOF
Linux Setup - Automated Cloud VM Configuration

Usage: sudo ./install.sh [OPTIONS]

Options:
  --minimal     Install only essential packages (curl, wget, git, vim, etc.)
  --full        Install all packages including development tools (default)
  --docker      Install Docker and container tools only
  --dev         Install development tools only
  --help        Display this help message

Examples:
  sudo ./install.sh                  # Full installation
  sudo ./install.sh --minimal        # Minimal installation
  sudo ./install.sh --docker --dev   # Install Docker and dev tools

EOF
    exit 0
}

################################################################################
# Installation Functions
################################################################################

update_system() {
    log "Updating system packages..."
    apt-get update -qq
    apt-get upgrade -y -qq
    log "System packages updated successfully"
}

install_essential_packages() {
    log "Installing essential packages..."
    
    if [[ -f "$SCRIPT_DIR/scripts/packages/essential.sh" ]]; then
        bash "$SCRIPT_DIR/scripts/packages/essential.sh"
    else
        log_warning "Essential packages script not found, installing manually..."
        apt-get install -y \
            curl \
            wget \
            git \
            vim \
            nano \
            htop \
            tmux \
            screen \
            tree \
            unzip \
            zip \
            tar \
            gzip \
            jq \
            ca-certificates \
            gnupg \
            lsb-release \
            software-properties-common \
            apt-transport-https
    fi
    
    log "Essential packages installed successfully"
}

install_dev_tools() {
    log "Installing development tools..."
    
    if [[ -f "$SCRIPT_DIR/scripts/packages/development.sh" ]]; then
        bash "$SCRIPT_DIR/scripts/packages/development.sh"
    else
        log_warning "Development tools script not found, installing manually..."
        apt-get install -y \
            build-essential \
            gcc \
            g++ \
            make \
            cmake \
            autoconf \
            automake \
            libtool \
            pkg-config \
            libssl-dev \
            libffi-dev \
            python3 \
            python3-pip \
            python3-venv
    fi
    
    log "Development tools installed successfully"
}

install_docker() {
    log "Installing Docker..."
    
    if [[ -f "$SCRIPT_DIR/scripts/packages/docker.sh" ]]; then
        bash "$SCRIPT_DIR/scripts/packages/docker.sh"
    else
        log_warning "Docker installation script not found, installing manually..."
        
        # Remove old versions
        apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
        
        # Install prerequisites
        apt-get install -y ca-certificates curl gnupg
        
        # Add Docker's official GPG key
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg
        
        # Set up the repository
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Install Docker Engine
        apt-get update -qq
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        # Enable and start Docker
        systemctl enable docker
        systemctl start docker
    fi
    
    log "Docker installed successfully"
}

setup_environment() {
    log "Setting up environment variables and configurations..."
    
    if [[ -f "$SCRIPT_DIR/scripts/config/environment.sh" ]]; then
        bash "$SCRIPT_DIR/scripts/config/environment.sh"
    else
        log_info "Environment configuration script not found, skipping..."
    fi
}

cleanup() {
    log "Cleaning up..."
    apt-get autoremove -y
    apt-get autoclean -y
    log "Cleanup completed"
}

display_summary() {
    log_info "============================================"
    log_info "Installation completed successfully!"
    log_info "Log file: $LOG_FILE"
    log_info "============================================"
    
    if command -v docker &> /dev/null; then
        log_info "Docker version: $(docker --version)"
    fi
    
    if command -v python3 &> /dev/null; then
        log_info "Python version: $(python3 --version)"
    fi
    
    if command -v git &> /dev/null; then
        log_info "Git version: $(git --version)"
    fi
}

################################################################################
# Main Script
################################################################################

main() {
    local install_minimal=false
    local install_full=true
    local install_docker_only=false
    local install_dev_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --minimal)
                install_minimal=true
                install_full=false
                shift
                ;;
            --full)
                install_full=true
                install_minimal=false
                shift
                ;;
            --docker)
                install_docker_only=true
                install_full=false
                shift
                ;;
            --dev)
                install_dev_only=true
                install_full=false
                shift
                ;;
            --help)
                display_help
                ;;
            *)
                log_error "Unknown option: $1"
                display_help
                ;;
        esac
    done
    
    log "Starting Linux Setup..."
    log "Script directory: $SCRIPT_DIR"
    
    check_root
    check_ubuntu
    
    update_system
    
    if [[ "$install_minimal" == true ]]; then
        install_essential_packages
    elif [[ "$install_docker_only" == true ]]; then
        install_essential_packages
        install_docker
    elif [[ "$install_dev_only" == true ]]; then
        install_essential_packages
        install_dev_tools
    else
        # Full installation
        install_essential_packages
        install_dev_tools
        install_docker
    fi
    
    setup_environment
    cleanup
    display_summary
    
    log "Installation completed! Please restart your shell or run: source ~/.bashrc"
}

# Run main function
main "$@"
