# ARM64 Github actions
FROM ubuntu:latest

ARG RUNNER_VERSION="2.311.0"

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y \
    curl docker.io docker-buildx sudo software-properties-common python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Prep the directory for the runner
RUN mkdir -p /opt/actions-runner && cd /opt/actions-runner
WORKDIR /opt/actions-runner

# Download the Gitub runner software & dependencies
RUN curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    ./bin/installdependencies.sh

################################
# Unique to this runner creation
################################
# Token from Github to create the runner with
ARG TOKEN
ARG RUNNER_NAME_PREFIX="runner-"
RUN echo "${RUNNER_NAME_PREFIX}$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)" > /runner_name.txt

# Setup the non-root user and downgrade from root
ARG DOCKER_GID=999
RUN groupmod -g ${DOCKER_GID} docker && useradd -m -s /bin/bash runner && usermod -aG docker runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && chown runner:runner -R /opt/actions-runner
USER runner
ENV PATH="/home/runner/.local/bin:$PATH"

######################
# Configure the runner
######################
# Name of the Github org to register this runner to
ARG ORGANIZATION
ENV TOKEN=${TOKEN}
ARG CUSTOM_LABELS=""
RUN if [ -z "$ORGANIZATION" ] || [ -z "$TOKEN" ]; then echo "ORGANIZATION and TOKEN arguments are required" && exit 1; fi
RUN ./config.sh --url https://github.com/${ORGANIZATION} --token ${TOKEN} --unattended --name $(cat /runner_name.txt) --labels ${CUSTOM_LABELS}

COPY entrypoint.sh /opt/actions-runner/entrypoint.sh

CMD [ "/opt/actions-runner/entrypoint.sh" ]
