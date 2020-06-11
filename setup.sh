#!/usr/bin/env bash

# Syntax: ./setup.sh <userName> <userUID> <userGID>

set -e

# Define script options and its defaults
userName=${1:-"vscode"}
userUID=${2:-1000}
userGID=${3:-1000}

# Ensure script execution as root
if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root.'
    exit 1
fi

# Update package lists
apt-get update

# Install general utilities
apt-get install -y \
    locales \
    neovim \
    sudo \
    zsh

# Install selected TeX Live packages and utilities
apt-get install -y \
    texlive \
    texlive-science \
    texlive-publishers \
    texlive-bibtex-extra \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-lang-english \
    texlive-lang-portuguese \
    cm-super \
    latexmk

# Clean up apt
rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 and pt_BR.UTF-8 locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Create non-root user
groupadd --gid ${userGID} ${userName}
useradd --uid ${userUID} --gid ${userGID} --shell $(which zsh) -m ${userName}

# Add sudo support for non-root user
echo "${userName} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${userName}
chmod 0440 /etc/sudoers.d/${userName}

# Create VS Code extensions folder for persistecy across containers ---
# see .devcontainer.json for a configuration example
mkdir -p /home/${userName}/.vscode-server/extensions
chown -R ${userName} /home/${userName}/.vscode-server