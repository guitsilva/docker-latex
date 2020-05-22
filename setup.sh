#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Modified version of the file
#
# https://github.com/microsoft/vscode-dev-containers/blob/master/script-library/common-debian.sh
#
# licensed under the MIT License below.
#-------------------------------------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE
#-------------------------------------------------------------------------------------------------------------

# Syntax: ./setup.sh <userName> <user UID> <user GID> <install zsh flag> 

set -e

# Define script options and its defaults
userName=${1:-"vscode"}
userUID=${2:-1000}
userGID=${3:-1000}
installZsh=${4:-"false"}

# Ensure script execution as root
if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root.'
    exit 1
fi

# Update package lists
apt-get update

# Install general utilities
apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    less \
    locales \
    neovim \
    openssh-client \
    sudo

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

# Generate en_US.UTF-8 and pt_BR.UTF-8 locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Create non-root user
groupadd --gid $userGID $userName
useradd --uid $userUID --gid $userGID -m $userName

# Add sudo support for non-root user
echo $userName ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$userName
chmod 0440 /etc/sudoers.d/$userName

# Ensure ~/.local/bin is in the PATH for root and non-root users for bash. (zsh is later)
echo "export PATH=\$PATH:\$HOME/.local/bin" | tee -a /root/.bashrc >> /home/$userName/.bashrc 
chown $userUID:$userGID /home/$userName/.bashrc

# Create VS Code extensions folder for persistent extensions across containers
mkdir -p /home/$userName/.vscode-server/extensions
chown -R $userName /home/$userName/.vscode-server

# Optionally install and configure zsh
if [ "$installZsh" = "true" ] && [ ! -d "/root/.oh-my-zsh" ]; then 
    apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "export PATH=\$PATH:\$HOME/.local/bin" >> /root/.zshrc
    cp -R /root/.oh-my-zsh /home/$userName
    cp /root/.zshrc /home/$userName
    sed -i -e "s/\/root\/.oh-my-zsh/\/home\/$userName\/.oh-my-zsh/g" /home/$userName/.zshrc
    chown -R $userUID:$userGID /home/$userName/.oh-my-zsh /home/$userName/.zshrc
fi

# Clean up
rm -rf /var/lib/apt/lists/*