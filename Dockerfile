FROM ubuntu:24.04

# Metadata
LABEL maintainer="linux-setup"
LABEL description="Ubuntu 24.04 LTS with essential development tools and utilities"
LABEL version="1.0"

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set working directory
WORKDIR /root

# Update system and install essential packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    # Essential utilities
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
    bzip2 \
    xz-utils \
    jq \
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
    sudo \
    # Development tools
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
    tk-dev \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python-is-python3 \
    # Version control
    git-lfs \
    # Additional utilities
    silversearcher-ag \
    ripgrep \
    fd-find \
    bat \
    shellcheck \
    yamllint && \
    # Cleanup
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Go
ENV GO_VERSION=1.21.5
RUN wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

# Install Docker CLI (for use with host Docker socket)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Set up environment variables
ENV PATH="/usr/local/go/bin:/root/.local/bin:/root/go/bin:${PATH}"
ENV EDITOR=vim
ENV VISUAL=vim

# Configure bash
RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "' >> /root/.bashrc && \
    echo 'alias ll="ls -lah"' >> /root/.bashrc && \
    echo 'alias la="ls -A"' >> /root/.bashrc && \
    echo 'alias ..="cd .."' >> /root/.bashrc && \
    echo 'alias gs="git status"' >> /root/.bashrc && \
    echo 'alias k="kubectl"' >> /root/.bashrc

# Create workspace directory
RUN mkdir -p /root/workspace

# Set working directory
WORKDIR /root/workspace

# Default command
CMD ["/bin/bash"]
