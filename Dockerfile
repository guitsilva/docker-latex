# Define base image: Ubuntu LTS
FROM buildpack-deps:focal

# Define maintainer
LABEL maintainer="Guilherme Tavares da Silva <guilherme.tsilva@gmail.com>"

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Set setup.sh arguments 
ARG userName="vscode"
ARG userUID=1000
ARG userGID=$userUID

# Copy local setup.sh to container
COPY setup.sh /tmp/

# Execute and remove setup.sh
RUN bash /tmp/setup.sh ${userName} ${userUID} ${userGID} \
    && rm /tmp/setup.sh

# Set container user and workdir
USER ${userName}
WORKDIR /home/${userName}

# Set default command
CMD ["zsh"]