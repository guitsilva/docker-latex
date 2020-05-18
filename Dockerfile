# Define base image: Ubuntu LTS
FROM ubuntu

# Define maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Set non-root user information 
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set setup.sh script options
ARG INSTALL_ZSH="true"
ARG SETUP_SCRIPT_SOURCE="https://raw.githubusercontent.com/guitsilva/docker-latex/develop/setup.sh"
ARG SETUP_SCRIPT_SHA="61502b0fd358705763ba5038bcda72392d06b11d94838b071937d59be1e2b00e"

# Run build commands
RUN apt-get update \
    # Download setup.sh
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${SETUP_SCRIPT_SOURCE} -o /tmp/setup.sh \
    # Check setup.sh SHA
    && ([ "${SETUP_SCRIPT_SHA}" = "dev-mode" ] || (echo "${SETUP_SCRIPT_SHA} /tmp/setup.sh" | sha256sum -c -)) \
    # Execute setup.sh
    && /bin/bash /tmp/setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    # Clean up
    && rm /tmp/setup.sh \
    && rm -rf /var/lib/apt/lists/*