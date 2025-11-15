# Linux Setup

Automated setup scripts and tools for configuring Ubuntu 24.04.3 LTS cloud VMs with essential packages, development tools, and environment configurations.

## 🚀 Quick Start

### Option 1: Direct Installation on VM

```bash
# Clone the repository
git clone https://github.com/rubyrose-alexis/linux-setup.git
cd linux-setup

# Run the installation script
sudo ./install.sh
```

### Option 2: Using Docker Container

```bash
# Build the Docker image
docker build -t ubuntu-devenv:latest .

# Run the container
docker run -it --rm ubuntu-devenv:latest

# Or run with volume mounting
docker run -it --rm -v $(pwd):/workspace ubuntu-devenv:latest
```

## 📦 Installation Options

The main installation script supports multiple modes:

### Full Installation (Default)
Installs everything: essential packages, development tools, and Docker.

```bash
sudo ./install.sh
```

### Minimal Installation
Installs only essential system utilities.

```bash
sudo ./install.sh --minimal
```

### Development Tools Only
Installs essential packages and development tools (no Docker).

```bash
sudo ./install.sh --dev
```

### Docker Only
Installs essential packages and Docker tools.

```bash
sudo ./install.sh --docker
```

## 📋 What Gets Installed

### Essential Packages (`--minimal`)
- **Utilities**: curl, wget, git, vim, nano, htop, tmux, screen, tree
- **Compression**: zip, unzip, tar, gzip, bzip2, xz-utils
- **Network Tools**: net-tools, iputils-ping, dnsutils, traceroute, netcat
- **System Tools**: jq, yq, rsync, bash-completion, openssh-client

### Development Tools (`--dev`)
- **Build Essentials**: gcc, g++, make, cmake, gdb
- **Libraries**: libssl-dev, libffi-dev, zlib1g-dev, and more
- **Python**: Python 3 with pip, venv, and development headers
- **Node.js**: Latest LTS version via NodeSource
- **Go**: Go 1.21.5
- **Version Control**: git, git-lfs, tig
- **Code Search**: ripgrep, silversearcher-ag, fd-find
- **Linters**: shellcheck, yamllint

### Container Tools (`--docker`)
- **Docker Engine**: Latest stable version
- **Docker Compose**: Plugin version (v2)
- **Docker Buildx**: Multi-platform builds
- **Containerd**: Container runtime

### Cloud CLI Tools (Optional)
Available in `scripts/packages/cloud-tools.sh`:
- AWS CLI v2
- Google Cloud SDK
- Azure CLI
- kubectl
- Helm
- Terraform

## 🔧 Environment Configuration

The installation automatically configures:

### Bash Environment
- Enhanced PATH with local binaries
- Useful aliases (ll, gs, k, docker shortcuts)
- Improved history settings
- Custom colored prompt
- Bash completion enabled

### Development Environment
- Go binaries in PATH
- Node.js and npm configured
- Python virtual environment support
- Rust/Cargo environment (if installed)

### Vim Configuration
- Syntax highlighting
- Line numbers
- Smart indentation
- Search improvements
- Mouse support

### Git Configuration
- Default branch set to 'main'
- Core editor set to vim
- Basic user-friendly defaults

## 📁 Project Structure

```
linux-setup/
├── install.sh                      # Main installation script
├── Dockerfile                      # Container image definition
├── scripts/
│   ├── packages/
│   │   ├── essential.sh           # Essential system packages
│   │   ├── development.sh         # Development tools
│   │   ├── docker.sh              # Docker installation
│   │   └── cloud-tools.sh         # Cloud CLI tools
│   ├── config/
│   │   └── environment.sh         # Environment configuration
│   └── utils/
│       ├── system-info.sh         # Display system information
│       └── update-system.sh       # System update utility
├── README.md
└── LICENSE
```

## 🛠️ Utility Scripts

### System Information
Display comprehensive system information:

```bash
bash scripts/utils/system-info.sh
```

Shows: OS version, CPU info, memory, disk usage, network interfaces, and installed tools.

### System Update
Update all packages and clean up:

```bash
sudo bash scripts/utils/update-system.sh
```

## 🐳 Docker Usage

### Building the Image

```bash
docker build -t ubuntu-devenv:latest .
```

### Running the Container

Basic usage:
```bash
docker run -it --rm ubuntu-devenv:latest
```

With volume mounting:
```bash
docker run -it --rm -v $(pwd):/workspace ubuntu-devenv:latest
```

With Docker socket (to use Docker inside container):
```bash
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock ubuntu-devenv:latest
```

With AWS credentials:
```bash
docker run -it --rm -v ~/.aws:/root/.aws ubuntu-devenv:latest
```

## 📝 Customization

### Adding Custom Packages

Edit the appropriate script in `scripts/packages/`:
- `essential.sh` - For system utilities
- `development.sh` - For dev tools
- `cloud-tools.sh` - For cloud CLIs

### Modifying Environment

Edit `scripts/config/environment.sh` to customize:
- PATH variables
- Aliases
- Shell prompt
- Git configuration

### Extending the Main Script

The `install.sh` script is modular and can be extended by:
1. Creating new scripts in `scripts/packages/`
2. Adding new functions in `install.sh`
3. Adding new command-line options

## 🔒 Security Considerations

- Always review scripts before running with sudo
- The Docker installation adds users to the docker group (requires logout)
- Cloud CLI tools are installed but require separate authentication
- SSH keys are not managed by these scripts

## 🐛 Troubleshooting

### Installation Fails
Check the log file at `/tmp/linux-setup-*.log` for detailed error messages.

### Docker Permission Denied
After Docker installation, log out and back in for group changes to take effect:
```bash
# Or manually start a new shell with the docker group
newgrp docker
```

### Command Not Found After Installation
Source your bashrc or restart your shell:
```bash
source ~/.bashrc
```

## 📊 System Requirements

- **OS**: Ubuntu 24.04.3 LTS (Noble Numbat)
- **Architecture**: x86_64 (amd64)
- **Kernel**: 6.8.0 or newer
- **Disk Space**: ~5GB for full installation
- **Memory**: 2GB minimum recommended
- **Network**: Internet connection required for package downloads

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚡ Quick Reference

```bash
# Full setup
sudo ./install.sh

# Install cloud tools separately
sudo bash scripts/packages/cloud-tools.sh

# Check system info
bash scripts/utils/system-info.sh

# Update system
sudo bash scripts/utils/update-system.sh

# Build Docker image
docker build -t ubuntu-devenv .

# Run Docker container
docker run -it --rm ubuntu-devenv
```

## 🔗 Useful Aliases (After Installation)

```bash
ll          # ls -lah (detailed list)
gs          # git status
k           # kubectl
dps         # docker ps
sysinfo     # system information
```
