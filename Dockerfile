# Ubuntu LTS
FROM ubuntu

# Maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Define non-root user 
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common package install script - SHA updated on release
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Add non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Create VSCode extensions folder
RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
    && chown -R $USERNAME /home/$USERNAME/.vscode-server

# Install packages
RUN apt-get update \
    # Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && ([ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || (echo "${COMMON_SCRIPT_SHA} /tmp/common-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && rm /tmp/common-setup.sh \
    #
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    # TeXLive -- non-full
    texlive \
    texlive-science \
    texlive-publishers \
    texlive-bibtex-extra \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-lang-english \
    texlive-lang-portuguese \
    # Utilities
    cm-super \
    git \
    gnupg \
    openssh-client \
    latexmk \
    # Remove trash
    && rm -rf /var/lib/apt/lists/*