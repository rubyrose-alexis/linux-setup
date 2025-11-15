#!/bin/bash

################################################################################
# Cloud CLI Tools Installation Script
#
# Description: Installs AWS CLI, Google Cloud SDK, Azure CLI, and other cloud tools
################################################################################

set -e

echo "Installing cloud CLI tools..."

# Install AWS CLI v2
echo "Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install
    rm -rf /tmp/aws /tmp/awscliv2.zip
fi

# Install Google Cloud SDK
echo "Installing Google Cloud SDK..."
if ! command -v gcloud &> /dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
        tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update -qq
    apt-get install -y google-cloud-sdk
fi

# Install Azure CLI
echo "Installing Azure CLI..."
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
fi

# Install kubectl
echo "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

# Install Helm
echo "Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install Terraform
echo "Installing Terraform..."
if ! command -v terraform &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update -qq
    apt-get install -y terraform
fi

echo "Cloud CLI tools installed successfully!"
echo ""
echo "Installed tools:"
command -v aws &> /dev/null && echo "  - AWS CLI: $(aws --version)"
command -v gcloud &> /dev/null && echo "  - Google Cloud SDK: $(gcloud --version | head -1)"
command -v az &> /dev/null && echo "  - Azure CLI: $(az --version | head -1)"
command -v kubectl &> /dev/null && echo "  - kubectl: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
command -v helm &> /dev/null && echo "  - Helm: $(helm version --short)"
command -v terraform &> /dev/null && echo "  - Terraform: $(terraform --version | head -1)"
