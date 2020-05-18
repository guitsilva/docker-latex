# Define base image: Ubuntu LTS
FROM ubuntu

# Define maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Set setup.sh arguments 
ARG installZsh="true"
ARG userName=vscode
ARG userUID=1000
ARG userGID=$userUID

# Copy local setup.sh to container
COPY setup.sh /tmp/

# Run build commands
RUN apt-get update \
    # Execute setup.sh
    && /bin/bash /tmp/setup.sh "${installZsh}" "${userName}" "${userUID}" "${userGID}" \
    # Clean up
    && rm /tmp/setup.sh \
    && rm -rf /var/lib/apt/lists/*