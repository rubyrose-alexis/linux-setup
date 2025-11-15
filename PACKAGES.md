# Installed Packages Reference

This document lists all packages and tools installed by the linux-setup scripts.

## Essential System Packages

### Core Utilities
- **curl** - Command-line tool for transferring data with URLs
- **wget** - Network downloader
- **git** - Distributed version control system
- **vim** - Text editor
- **nano** - Simple text editor
- **tree** - Directory listing in tree format
- **less** - File pager
- **man-db** - Manual pages
- **rsync** - Fast file synchronization tool

### System Monitoring
- **htop** - Interactive process viewer
- **btop** - Modern resource monitor
- **tmux** - Terminal multiplexer
- **screen** - Screen manager with terminal emulation

### Compression Tools
- **zip** / **unzip** - ZIP archive tools
- **tar** - Tape archiver
- **gzip** - GNU compression utility
- **bzip2** - Block-sorting file compressor
- **xz-utils** - XZ compression utilities

### Network Tools
- **net-tools** - Network utilities (ifconfig, netstat, etc.)
- **iputils-ping** - Tools to test network reachability
- **dnsutils** - DNS utilities (dig, nslookup)
- **traceroute** - Network route tracer
- **netcat-openbsd** - TCP/IP swiss army knife
- **openssh-client** - SSH client

### Data Processing
- **jq** - JSON processor
- **yq** - YAML processor

### System Libraries
- **ca-certificates** - Common CA certificates
- **gnupg** - GNU Privacy Guard
- **lsb-release** - Linux Standard Base version reporting
- **software-properties-common** - Manage software repositories
- **apt-transport-https** - HTTPS support for APT

## Development Tools

### Build Tools
- **build-essential** - Informational list of build-essential packages
- **gcc** - GNU C compiler
- **g++** - GNU C++ compiler
- **gdb** - GNU Debugger
- **make** - GNU Make build tool
- **cmake** - Cross-platform build system
- **autoconf** - Automatic configure script builder
- **automake** - Tool for generating Makefile.in
- **libtool** - Generic library support script
- **pkg-config** - System for managing library compile/link flags

### Development Libraries
- **libssl-dev** - SSL development libraries
- **libffi-dev** - Foreign Function Interface library
- **libreadline-dev** - GNU readline and history libraries
- **zlib1g-dev** - Compression library
- **libbz2-dev** - Bzip2 library
- **libsqlite3-dev** - SQLite 3 development files
- **libncurses5-dev** - Terminal handling library
- **libncursesw5-dev** - Terminal handling library (wide character)
- **libgdbm-dev** - GNU dbm database routines
- **liblzma-dev** - XZ compression library
- **tk-dev** - Toolkit for Tcl and X11

### Programming Languages

#### Python
- **python3** - Python 3 interpreter
- **python3-pip** - Python package installer
- **python3-venv** - Python virtual environment support
- **python3-dev** - Header files for Python
- **python-is-python3** - Symlink python to python3

#### Node.js
- **nodejs** - JavaScript runtime (LTS version from NodeSource)
- **npm** - Node.js package manager (included with nodejs)

#### Go
- **Go 1.21.5** - Installed from official binaries
  - Location: `/usr/local/go`
  - Binary: `/usr/local/go/bin/go`

### Version Control
- **git** - Distributed version control
- **git-lfs** - Git Large File Storage
- **tig** - Text-mode interface for Git

### Code Search and Analysis
- **silversearcher-ag** - Fast code searching tool
- **ripgrep** - Recursive line-oriented search tool
- **fd-find** - Simple, fast alternative to 'find'
- **bat** - Cat clone with syntax highlighting
- **shellcheck** - Shell script analysis tool
- **yamllint** - YAML linter

## Container Technologies

### Docker
- **docker-ce** - Docker Community Edition
- **docker-ce-cli** - Docker CLI
- **containerd.io** - Container runtime
- **docker-buildx-plugin** - Docker CLI plugin for extended build
- **docker-compose-plugin** - Docker CLI plugin for Docker Compose (v2)

## Cloud CLI Tools (Optional)

### AWS
- **AWS CLI v2** - Amazon Web Services command-line interface
  - Location: `/usr/local/bin/aws`
  - Installed via official installer

### Google Cloud
- **google-cloud-sdk** - Google Cloud Platform CLI
  - Includes: gcloud, gsutil, bq
  - Repository: packages.cloud.google.com

### Azure
- **azure-cli** - Microsoft Azure command-line interface
  - Package name: azure-cli
  - Installed via Microsoft's Debian repository

### Kubernetes
- **kubectl** - Kubernetes command-line tool
  - Location: `/usr/local/bin/kubectl`
  - Version: Latest stable
- **helm** - Kubernetes package manager
  - Location: `/usr/local/bin/helm`
  - Version: Helm 3

### Infrastructure as Code
- **terraform** - Infrastructure as Code tool
  - Repository: apt.releases.hashicorp.com
  - Location: `/usr/bin/terraform`

## Environment Configuration

### Shell Customizations
- Enhanced `.bashrc` with:
  - Custom aliases
  - Improved PATH
  - Better history settings
  - Colored prompt
  - Bash completion

### Editor Configuration
- `.vimrc` with sensible defaults:
  - Syntax highlighting
  - Line numbers
  - Smart indentation
  - Search improvements

### Git Configuration
- Default branch: main
- Core editor: vim
- Pull strategy: merge (no rebase)

## Disk Space Requirements

Approximate disk space for different installation types:

- **Minimal**: ~500MB
- **Full (without cloud tools)**: ~3GB
- **Full (with cloud tools)**: ~5GB
- **Docker container image**: ~2.5GB

## Package Versions

Most packages are installed from Ubuntu 24.04 LTS repositories, which means they receive security updates but maintain stable versions throughout the LTS lifecycle.

Exceptions (installed from external sources):
- **Node.js**: Latest LTS from NodeSource
- **Go**: Specific version (1.21.5) from official binaries
- **Docker**: Latest stable from Docker's repository
- **AWS CLI**: Version 2 from AWS
- **Cloud tools**: Latest from respective vendors

## Updating Packages

### System Packages
```bash
sudo apt update
sudo apt upgrade
```

### Docker
```bash
sudo apt update
sudo apt upgrade docker-ce docker-ce-cli containerd.io
```

### Cloud Tools
```bash
# AWS CLI
sudo /usr/local/aws-cli/v2/current/bin/aws --version

# Google Cloud SDK
gcloud components update

# Azure CLI
az upgrade
```

### Language-Specific Package Managers
```bash
# Python packages
pip3 install --upgrade pip
pip3 list --outdated

# Node.js packages
npm update -g

# Go modules
go get -u
```

## Package Dependencies

The installation is designed to be idempotent - running it multiple times won't cause issues. Dependencies are automatically resolved by apt and other package managers.

## Removal

To remove packages installed by this setup:

```bash
# List packages installed by specific scripts
dpkg -l | grep <package-name>

# Remove specific package
sudo apt remove <package-name>

# Remove with configuration files
sudo apt purge <package-name>

# Clean up unused dependencies
sudo apt autoremove
```
