# Define base image
FROM buildpack-deps:focal

# Define maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Set non-root user info
ARG userName="vscode"
ARG userUID=1000
ARG userGID=${userUID}

# Install general utilities
RUN apt-get update && apt-get install -y \
    direnv \
    locales \
    neovim \
    sudo \
    zsh && \
    #
    rm -rf /var/lib/apt/lists/*

# Install selected TeX Live packages
RUN apt-get update && apt-get install -y \
    texlive \
    texlive-science \
    texlive-publishers \
    texlive-bibtex-extra \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-lang-english \
    texlive-lang-portuguese \
    cm-super \
    latexmk && \
    #
    rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 and pt_BR.UTF-8 locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
    locale-gen

# Create non-root user
RUN groupadd --gid ${userGID} ${userName} && \
    useradd --uid ${userUID} --gid ${userGID} \
        --shell $(which zsh) --create-home ${userName}

# Add sudo support for non-root user
RUN echo "${userName} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${userName} && \
    chmod 0440 /etc/sudoers.d/${userName}

# Create non-root user's private bin folder
RUN [ ! -d /home/${userName}/.local/bin ] && \
    mkdir -p /home/${userName}/.local/bin

# Add non-root user's private bin folder to PATH
ENV PATH="/home/${userName}/.local/bin:${PATH}"

# Create VS Code extensions folder for persistency
RUN mkdir -p /home/${userName}/.vscode-server/extensions && \
    chown -R ${userName} /home/${userName}/.vscode-server

# Set default user and workdir
USER ${userName}
WORKDIR /home/${userName}

# Set default command
CMD ["zsh"]