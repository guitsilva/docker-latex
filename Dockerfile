# Ubuntu LTS
FROM ubuntu

# Maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Define non-root user 
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Setup Script options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Install packages
RUN apt-get update \
    # Download and execute Setup Script: install useful packages, generate locales,
    # add non-root user and optionally install oh-my-zsh 
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && ([ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || (echo "${COMMON_SCRIPT_SHA} /tmp/common-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && rm /tmp/common-setup.sh \
    #
    # Install selected TeX Live packages and utilities
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    texlive \
    texlive-science \
    texlive-publishers \
    texlive-bibtex-extra \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-lang-english \
    texlive-lang-portuguese \
    cm-super \
    latexmk \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create VS Code extensions folder for persistent extensions across containers
RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
    && chown -R $USERNAME /home/$USERNAME/.vscode-server