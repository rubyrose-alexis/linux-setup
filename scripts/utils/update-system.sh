#!/bin/bash

################################################################################
# System Update Script
#
# Description: Updates system packages and cleans up
################################################################################

set -e

# Color codes
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $*"
}

log_info() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')] INFO:${NC} $*"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo"
    exit 1
fi

log "Starting system update..."

log "Updating package lists..."
apt-get update -qq

log "Upgrading packages..."
apt-get upgrade -y

log "Performing distribution upgrade..."
apt-get dist-upgrade -y

log "Removing unnecessary packages..."
apt-get autoremove -y

log "Cleaning package cache..."
apt-get autoclean -y
apt-get clean -y

# Update snap packages if snap is installed
if command -v snap &> /dev/null; then
    log "Updating snap packages..."
    snap refresh
fi

# Check if reboot is required
if [ -f /var/run/reboot-required ]; then
    log_info "=========================================="
    log_info "REBOOT REQUIRED"
    log_info "System updates require a reboot"
    log_info "Reboot reason(s):"
    cat /var/run/reboot-required.pkgs 2>/dev/null || echo "  (details not available)"
    log_info "=========================================="
else
    log "System is up to date. No reboot required."
fi

log "System update completed successfully!"
