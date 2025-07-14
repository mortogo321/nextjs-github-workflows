#!/bin/bash

set -e

# === Config ===
REPO="mortogo321/nextjs-github-workflows"
RUNNER_NAME="nextjs-web-runner"
LABELS="web,nextjs"
IMAGE_NAME="github-runner"
CONTAINER_NAME="github-runner"
GH_RUNNER_URL="https://github.com/${REPO}"
RUNNER_HOME="/home/runner/actions-runner"
RUNNER_VOLUME="/opt/nextjs-github-workflows/web/github-runner"

# === Read token from env or arg ===
GH_RUNNER_TOKEN="${GH_RUNNER_TOKEN:-$1}"

if [ -z "$GH_RUNNER_TOKEN" ]; then
    echo "❌ GH_RUNNER_TOKEN is required."
    echo "Usage: GH_RUNNER_TOKEN=runner_token ./github-runner.sh"
    echo "   or: ./github-runner.sh runner_token"
    exit 1
fi

# === Get latest runner version ===
echo "🔍 Fetching latest GitHub Actions runner version..."
RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name | sed 's/^v//')
echo "📦 Using runner version: $RUNNER_VERSION"

# === Build image ===
echo "🐳 Building image..."
docker build --build-arg RUNNER_VERSION="$RUNNER_VERSION" -t "$IMAGE_NAME" .

# === Remove old container if exists ===
echo "🧹 Removing existing container (if any)..."
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# === Get docker.sock GID from host ===
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
echo "🔐 Detected docker.sock GID: $DOCKER_GID"

# === Start the runner ===
echo "🚀 Starting GitHub Actions runner container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    --user runner \
    --group-add "$DOCKER_GID" \
    -e GH_RUNNER_URL="$GH_RUNNER_URL" \
    -e GH_RUNNER_TOKEN="$GH_RUNNER_TOKEN" \
    -e GH_RUNNER_NAME="$RUNNER_NAME" \
    -e GH_RUNNER_LABELS="$LABELS" \
    -v "$RUNNER_VOLUME":"$RUNNER_HOME" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /opt:/opt \
    "$IMAGE_NAME"
