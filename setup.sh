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

# Syntax: ./setup.sh <install zsh flag> <userName> <user UID> <user GID>

set -e

# Define script options and its defaults
installZsh=${1:-"true"}
userName=${2:-"$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)"}
userUID=${3:-1000}
userGID=${4:-1000}

# Ensure script execution as root
if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run a root. Use sudo or set "USER root" before running the script.'
    exit 1
fi

# Update package lists
apt-get update

# Install common dependencies
apt-get -y install --no-install-recommends \
    git \
    openssh-client \
    less \
    iproute2 \
    procps \
    curl \
    wget \
    unzip \
    nano \
    jq \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    dialog \
    gnupg \
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu[0-9][0-9] \
    liblttng-ust0 \
    libstdc++6 \
    libssl1.1 \
    sudo \
    zlib1g \
    locales

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

# Ensure at least the en_US.UTF-8 UTF-8 locale is available.
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen

# Create or update a non-root user to match UID/GID - see https://aka.ms/vscode-remote/containers/non-root-user.
if id -u $userName > /dev/null 2>&1; then
    # User exists, update if needed
    if [ "$userGID" != "$(id -G $userName)" ]; then 
        groupmod --gid $userGID $userName 
        usermod --gid $userGID $userName
    fi
    if [ "$userUID" != "$(id -u $userName)" ]; then 
        usermod --uid $userUID $userName
    fi
else
    # Create user
    groupadd --gid $userGID $userName
    useradd -s /bin/bash --uid $userUID --gid $userGID -m $userName
fi

# Add sudo support for non-root user
echo $userName ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$userName
chmod 0440 /etc/sudoers.d/$userName

# Ensure ~/.local/bin is in the PATH for root and non-root users for bash. (zsh is later)
echo "export PATH=\$PATH:\$HOME/.local/bin" | tee -a /root/.bashrc >> /home/$userName/.bashrc 
chown $userUID:$userGID /home/$userName/.bashrc

# Create VS Code extensions folder for persistent extensions across containers
RUN mkdir -p /home/$userName/.vscode-server/extensions \
    && chown -R $userName /home/$userName/.vscode-server

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