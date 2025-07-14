FROM ubuntu:latest

ARG RUNNER_VERSION
ENV RUNNER_VERSION=${RUNNER_VERSION}
ENV RUNNER_HOME=/home/runner/actions-runner
ENV DEBIAN_FRONTEND=noninteractive

# --- Install dependencies ---
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    sudo \
    jq \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Add Docker's official GPG key ---
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# --- Add Docker repository ---
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- Install Docker CLI + Compose v2 ---
RUN apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin

# --- Create runner user and home directory ---
RUN useradd -m -s /bin/bash runner && \
    mkdir -p $RUNNER_HOME && \
    chown -R runner:runner $RUNNER_HOME

# --- Switch to runner user ---
USER runner
WORKDIR $RUNNER_HOME

# --- Download GitHub Actions Runner ---
RUN curl -L -o actions-runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

# --- Copy entrypoint script ---
COPY --chown=runner:runner entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
