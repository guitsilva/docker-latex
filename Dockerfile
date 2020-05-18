# Define base image: Ubuntu LTS
FROM ubuntu

# Define maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Set non-root user information 
ARG userName=vscode
ARG userUID=1000
ARG userGID=$userUID

# Set setup.sh script options
ARG installZsh="true"
ARG setupScriptSource="https://raw.githubusercontent.com/guitsilva/docker-latex/develop/setup.sh"
ARG setupScriptSHA="f81e0e1a27b866f29c50b38496d7d4cdcfb9dc466fdc783fa034bd4861bc55bd"

# Run build commands
RUN apt-get update \
    # Download setup.sh
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${setupScriptSource} -o /tmp/setup.sh \
    # Check setup.sh SHA
    && (echo "${setupScriptSHA} /tmp/setup.sh" | sha256sum -c -) \
    # Execute setup.sh
    && /bin/bash /tmp/setup.sh "${installZsh}" "${userName}" "${userUID}" "${userGID}" \
    # Clean up
    && rm /tmp/setup.sh \
    && rm -rf /var/lib/apt/lists/*