#!/bin/bash

################################################################################
# System Information Script
#
# Description: Displays comprehensive system information
################################################################################

# Color codes
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

print_section() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_section "System Information"
echo "Hostname: $(hostname)"
echo "OS: $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Uptime: $(uptime -p)"

print_section "CPU Information"
echo "Model: $(lscpu | grep 'Model name' | cut -d ':' -f 2 | xargs)"
echo "Cores: $(nproc)"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"

print_section "Memory Information"
free -h

print_section "Disk Usage"
df -h --total | grep -E '^/dev/|^Filesystem|total'

print_section "Network Interfaces"
ip -brief address

print_section "Installed Development Tools"
for cmd in git docker python3 node go kubectl terraform aws gcloud az; do
    if command -v $cmd &> /dev/null; then
        case $cmd in
            python3)
                echo -e "${GREEN}✓${NC} Python: $(python3 --version 2>&1)"
                ;;
            node)
                echo -e "${GREEN}✓${NC} Node.js: $(node --version 2>&1)"
                ;;
            go)
                echo -e "${GREEN}✓${NC} Go: $(go version 2>&1)"
                ;;
            docker)
                echo -e "${GREEN}✓${NC} Docker: $(docker --version 2>&1)"
                ;;
            git)
                echo -e "${GREEN}✓${NC} Git: $(git --version 2>&1)"
                ;;
            kubectl)
                echo -e "${GREEN}✓${NC} kubectl: $(kubectl version --client --short 2>/dev/null || echo "installed")"
                ;;
            terraform)
                echo -e "${GREEN}✓${NC} Terraform: $(terraform --version 2>&1 | head -1)"
                ;;
            aws)
                echo -e "${GREEN}✓${NC} AWS CLI: $(aws --version 2>&1)"
                ;;
            gcloud)
                echo -e "${GREEN}✓${NC} Google Cloud SDK: $(gcloud --version 2>&1 | head -1)"
                ;;
            az)
                echo -e "${GREEN}✓${NC} Azure CLI: $(az --version 2>&1 | head -1)"
                ;;
        esac
    else
        echo -e "${YELLOW}✗${NC} $cmd: not installed"
    fi
done

print_section "Active Services"
systemctl list-units --type=service --state=running --no-pager | head -10

echo ""
