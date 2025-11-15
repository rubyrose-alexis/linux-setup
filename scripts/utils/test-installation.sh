#!/bin/bash

################################################################################
# Test Installation Script
#
# Description: Validates that installed tools and configurations work correctly
################################################################################

# Color codes
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

check_command() {
    local cmd="$1"
    local description="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $description: $(command -v "$cmd")"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $description: not found"
        ((FAILED++))
        return 1
    fi
}

check_optional_command() {
    local cmd="$1"
    local description="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $description: $(command -v "$cmd")"
        ((PASSED++))
        return 0
    else
        echo -e "${YELLOW}○${NC} $description: not installed (optional)"
        ((WARNINGS++))
        return 1
    fi
}

check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $description: exists"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $description: not found"
        ((FAILED++))
        return 1
    fi
}

check_directory() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $description: exists"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $description: not found"
        ((FAILED++))
        return 1
    fi
}

check_in_path() {
    local path_entry="$1"
    local description="$2"
    
    if [[ ":$PATH:" == *":$path_entry:"* ]]; then
        echo -e "${GREEN}✓${NC} $description: in PATH"
        ((PASSED++))
        return 0
    else
        echo -e "${YELLOW}!${NC} $description: not in PATH"
        ((WARNINGS++))
        return 1
    fi
}

test_docker() {
    if command -v docker &> /dev/null; then
        if docker ps &> /dev/null; then
            echo -e "${GREEN}✓${NC} Docker: running and accessible"
            ((PASSED++))
        else
            echo -e "${YELLOW}!${NC} Docker: installed but not accessible (try: sudo usermod -aG docker \$USER && newgrp docker)"
            ((WARNINGS++))
        fi
    fi
}

# Main tests
print_header "Testing Essential Commands"

check_command "curl" "curl"
check_command "wget" "wget"
check_command "git" "git"
check_command "vim" "vim"
check_command "htop" "htop"
check_command "tmux" "tmux"
check_command "jq" "jq"
check_command "tree" "tree"

print_header "Testing Development Tools"

check_command "gcc" "GCC compiler"
check_command "make" "Make build tool"
check_optional_command "python3" "Python 3"
check_optional_command "pip3" "pip3"
check_optional_command "node" "Node.js"
check_optional_command "npm" "npm"
check_optional_command "go" "Go"

print_header "Testing Container Tools"

check_optional_command "docker" "Docker"
test_docker

print_header "Testing Cloud Tools"

check_optional_command "aws" "AWS CLI"
check_optional_command "gcloud" "Google Cloud SDK"
check_optional_command "az" "Azure CLI"
check_optional_command "kubectl" "kubectl"
check_optional_command "terraform" "Terraform"
check_optional_command "helm" "Helm"

print_header "Testing Configuration Files"

check_file "$HOME/.bashrc" "Bash configuration"
check_file "$HOME/.vimrc" "Vim configuration"

print_header "Testing Directories"

check_directory "$HOME/workspace" "Workspace directory"
check_directory "$HOME/.local/bin" "Local bin directory"

print_header "Testing PATH Configuration"

check_in_path "/usr/local/bin" "/usr/local/bin"
check_in_path "$HOME/.local/bin" "\$HOME/.local/bin"

# Check for specific configurations in bashrc
print_header "Testing Bash Configuration"

if grep -q "Custom configurations added by linux-setup" "$HOME/.bashrc" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Custom bash configurations: found"
    ((PASSED++))
else
    echo -e "${YELLOW}!${NC} Custom bash configurations: not found"
    ((WARNINGS++))
fi

# Summary
print_header "Test Summary"

TOTAL=$((PASSED + FAILED + WARNINGS))
echo -e "Total Tests: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "${RED}Failed: $FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All critical tests passed!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}Note: Some optional components are not installed.${NC}"
    fi
    exit 0
else
    echo -e "\n${RED}Some tests failed. Please review the output above.${NC}"
    exit 1
fi
