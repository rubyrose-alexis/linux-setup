#!/bin/bash

################################################################################
# Environment Configuration Script
#
# Description: Sets up environment variables, PATH, and shell customizations
################################################################################

set -e

echo "Configuring environment..."

# Get the actual user (not root if running with sudo)
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo "~$ACTUAL_USER")

# Backup existing configurations
backup_config() {
    local config_file="$1"
    if [[ -f "$config_file" ]]; then
        cp "$config_file" "${config_file}.backup-$(date +%Y%m%d-%H%M%S)"
        echo "Backed up $config_file"
    fi
}

# Configure bashrc
configure_bashrc() {
    local bashrc="$ACTUAL_HOME/.bashrc"
    
    echo "Configuring ~/.bashrc..."
    backup_config "$bashrc"
    
    # Create bashrc if it doesn't exist
    if [[ ! -f "$bashrc" ]]; then
        touch "$bashrc"
        chown "$ACTUAL_USER:$ACTUAL_USER" "$bashrc"
    fi
    
    # Add custom configurations
    cat >> "$bashrc" << 'EOF'

# ============================================================================
# Custom configurations added by linux-setup
# ============================================================================

# Enhanced PATH
export PATH="/usr/local/bin:/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"

# Editor preferences
export EDITOR=vim
export VISUAL=vim

# History configuration
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Docker aliases (if Docker is installed)
if command -v docker &> /dev/null; then
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlog='docker logs'
    alias dstop='docker stop $(docker ps -aq)'
    alias drm='docker rm $(docker ps -aq)'
fi

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# System information
alias sysinfo='echo "=== System Information ===" && uname -a && echo "" && echo "=== CPU Info ===" && lscpu | grep "Model name" && echo "" && echo "=== Memory ===" && free -h && echo "" && echo "=== Disk Usage ===" && df -h /'

# Kubernetes aliases (if kubectl is installed)
if command -v kubectl &> /dev/null; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
    alias kdp='kubectl describe pod'
    alias klog='kubectl logs'
fi

# Custom prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Node version manager (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Rust environment (if installed)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

EOF
    
    chown "$ACTUAL_USER:$ACTUAL_USER" "$bashrc"
    echo "~/.bashrc configured successfully"
}

# Configure git
configure_git() {
    echo "Setting up git configuration..."
    
    # Set useful git defaults if not already configured
    su - "$ACTUAL_USER" -c "git config --global init.defaultBranch main 2>/dev/null || true"
    su - "$ACTUAL_USER" -c "git config --global pull.rebase false 2>/dev/null || true"
    su - "$ACTUAL_USER" -c "git config --global core.editor vim 2>/dev/null || true"
    
    echo "Git configuration completed"
}

# Create useful directories
create_directories() {
    echo "Creating useful directories..."
    
    local dirs=(
        "$ACTUAL_HOME/workspace"
        "$ACTUAL_HOME/projects"
        "$ACTUAL_HOME/bin"
        "$ACTUAL_HOME/.local/bin"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            chown "$ACTUAL_USER:$ACTUAL_USER" "$dir"
            echo "Created $dir"
        fi
    done
}

# Configure vim
configure_vim() {
    local vimrc="$ACTUAL_HOME/.vimrc"
    
    echo "Configuring vim..."
    
    if [[ ! -f "$vimrc" ]]; then
        cat > "$vimrc" << 'EOF'
" Basic vim configuration
syntax on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set ruler
set wildmenu
set mouse=a
set clipboard=unnamedplus
set encoding=utf-8
set backspace=indent,eol,start

" Color scheme
colorscheme desert

" Enable file type detection
filetype plugin indent on
EOF
        
        chown "$ACTUAL_USER:$ACTUAL_USER" "$vimrc"
        echo "Created ~/.vimrc"
    else
        echo "~/.vimrc already exists, skipping..."
    fi
}

# Main execution
main() {
    configure_bashrc
    configure_git
    create_directories
    configure_vim
    
    echo ""
    echo "Environment configuration completed!"
    echo "Please run 'source ~/.bashrc' or restart your shell to apply changes"
}

main
