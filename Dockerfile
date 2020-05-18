# Ubuntu LTS
FROM ubuntu

# Maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Define non-root user 
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Setup Script options
ARG INSTALL_ZSH="true"
ARG SETUP_SCRIPT_SOURCE="https://raw.githubusercontent.com/guitsilva/docker-latex/develop/setup.sh"
ARG SETUP_SCRIPT_SHA="61502b0fd358705763ba5038bcda72392d06b11d94838b071937d59be1e2b00e"

# Install packages
RUN apt-get update \
    # Download and execute Setup Script: install useful packages, generate locales,
    # add non-root user and optionally install oh-my-zsh 
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${SETUP_SCRIPT_SOURCE} -o /tmp/setup.sh \
    && ([ "${SETUP_SCRIPT_SHA}" = "dev-mode" ] || (echo "${SETUP_SCRIPT_SHA} /tmp/setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm /tmp/setup.sh \
    #
    # Install selected TeX Live packages and utilities
    && apt-get install -y \
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