# Examples Directory

This directory contains example configurations and helper files for using linux-setup in various scenarios.

## Files

### cloud-init.yaml
Complete cloud-init configuration for automatic VM setup.

**Use with:**
- AWS EC2 (as user-data)
- Google Cloud Compute (as startup script, convert to shell format)
- Azure VMs (as custom data)
- DigitalOcean Droplets (as user data)
- Any cloud provider supporting cloud-init

**Features:**
- Automatic package updates
- Clone and run linux-setup
- Create welcome message
- Optional user creation
- Configurable installation mode

**Usage:**
```bash
# AWS CLI example
aws ec2 run-instances \
  --image-id ami-0c7217cdde317cfec \
  --instance-type t2.micro \
  --user-data file://cloud-init.yaml

# Or paste the content in the cloud provider's web console
```

### user-data.sh
Bash script for VM initialization, simpler alternative to cloud-init.

**Use with:**
- AWS EC2 user-data
- Any cloud provider accepting shell scripts
- Manual execution on new VMs

**Usage:**
```bash
# AWS CLI example
aws ec2 run-instances \
  --image-id ami-0c7217cdde317cfec \
  --instance-type t2.micro \
  --user-data file://user-data.sh

# Manual execution
sudo bash user-data.sh
```

### Makefile
Convenient shortcuts for common tasks.

**Usage:**
```bash
# Copy to project root
cp examples/Makefile .

# Use make commands
make help              # Show available commands
make install           # Full installation
make install-minimal   # Minimal installation
make docker-build      # Build Docker image
make system-info       # Show system info
make update            # Update system
```

## Common Scenarios

### 1. AWS EC2 Launch

Using AWS Console:
1. Launch new EC2 instance
2. Under "Advanced Details" → "User data"
3. Paste contents of `cloud-init.yaml` or `user-data.sh`
4. Launch instance
5. SSH in after a few minutes when setup completes

Using AWS CLI:
```bash
aws ec2 run-instances \
  --image-id ami-0c7217cdde317cfec \
  --instance-type t3.medium \
  --key-name your-key-pair \
  --security-group-ids sg-xxxxx \
  --subnet-id subnet-xxxxx \
  --user-data file://examples/cloud-init.yaml
```

### 2. Google Cloud Compute Engine

```bash
gcloud compute instances create my-dev-vm \
  --image-family=ubuntu-2404-lts-amd64 \
  --image-project=ubuntu-os-cloud \
  --machine-type=n1-standard-2 \
  --metadata-from-file startup-script=examples/user-data.sh
```

### 3. Azure Virtual Machine

```bash
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image Ubuntu2404 \
  --custom-data examples/cloud-init.yaml \
  --admin-username azureuser \
  --generate-ssh-keys
```

### 4. DigitalOcean Droplet

Using DigitalOcean CLI:
```bash
doctl compute droplet create my-droplet \
  --image ubuntu-24-04-x64 \
  --size s-2vcpu-4gb \
  --region nyc3 \
  --user-data-file examples/cloud-init.yaml
```

Or use the web interface and paste the cloud-init content in "User data" section.

### 5. Terraform

```hcl
# main.tf
resource "aws_instance" "dev_vm" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.medium"
  
  user_data = file("${path.module}/examples/cloud-init.yaml")
  
  tags = {
    Name = "dev-vm-linux-setup"
  }
}
```

### 6. Packer

```json
{
  "builders": [{
    "type": "amazon-ebs",
    "region": "us-east-1",
    "source_ami": "ami-0c7217cdde317cfec",
    "instance_type": "t3.medium",
    "ssh_username": "ubuntu",
    "ami_name": "ubuntu-devenv-{{timestamp}}"
  }],
  "provisioners": [{
    "type": "shell",
    "script": "examples/user-data.sh"
  }]
}
```

## Customizing Examples

### Modify Installation Mode

In `cloud-init.yaml` or `user-data.sh`, change the installation command:

```bash
# Minimal installation
./install.sh --minimal

# Full installation
./install.sh --full

# Docker only
./install.sh --docker

# Dev tools only
./install.sh --dev
```

### Add Cloud CLI Tools

Add to the runcmd section:
```yaml
runcmd:
  - cd /opt/linux-setup && ./install.sh --full
  - bash /opt/linux-setup/scripts/packages/cloud-tools.sh
```

### Create Custom Users

In `cloud-init.yaml`, uncomment and modify:
```yaml
users:
  - name: developer
    groups: sudo, docker
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAA...your-key...
```

### Install Additional Packages

Add to runcmd:
```yaml
runcmd:
  - apt-get install -y postgresql-client redis-tools
```

## Verification

After VM creation, verify the setup:

```bash
# SSH into VM
ssh ubuntu@your-vm-ip

# Check if linux-setup completed
ls -la /opt/linux-setup

# View installation log
cat /var/log/user-data.log

# Check system info
bash /opt/linux-setup/scripts/utils/system-info.sh

# Verify Docker (if installed)
docker --version
```

## Troubleshooting

### Cloud-init logs

```bash
# View cloud-init output
sudo cat /var/log/cloud-init-output.log

# Check cloud-init status
sudo cloud-init status
```

### User-data logs

```bash
# View user-data execution log
sudo cat /var/log/user-data.log

# Check system logs
sudo journalctl -u cloud-init
```

### Common Issues

**Installation didn't run:**
- Check if cloud-init/user-data is supported by your image
- Verify the script syntax
- Check VM has internet access

**Partial installation:**
- Check logs for errors
- Manually re-run: `sudo /opt/linux-setup/install.sh`

**Docker not accessible:**
- Log out and back in: `exit` then SSH again
- Or: `newgrp docker`

## Tips

1. **Test locally first**: Run scripts manually on a test VM before using in automation

2. **Monitor progress**: Use cloud provider's console to monitor instance initialization

3. **Keep it simple**: Start with minimal installation, add more later

4. **Version control**: Fork the repository and customize for your needs

5. **Security**: Don't put secrets in user-data; use parameter stores or secrets managers

6. **Logs**: Always check logs if something doesn't work as expected

## Contributing

Found a useful configuration? Submit a PR to add more examples!
