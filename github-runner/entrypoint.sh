#!/bin/bash
set -e

# Optional: fix permissions on docker.sock
if [ -S /var/run/docker.sock ]; then
    chgrp docker /var/run/docker.sock || true
    chmod g+rw /var/run/docker.sock || true
fi

if [[ -z "$GH_RUNNER_URL" || -z "$GH_RUNNER_TOKEN" || -z "$GH_RUNNER_NAME" ]]; then
    echo "❌ Required environment variables missing:"
    echo "  GH_RUNNER_URL, GH_RUNNER_TOKEN, GH_RUNNER_NAME"
    exit 1
fi

if [ ! -f ".runner" ]; then
    echo "🔑 Configuring GitHub runner..."
    ./config.sh \
        --url "$GH_RUNNER_URL" \
        --token "$GH_RUNNER_TOKEN" \
        --name "$GH_RUNNER_NAME" \
        --labels "${GH_RUNNER_LABELS:-self-hosted}" \
        --unattended \
        --replace
else
    echo "🔁 Runner already configured."
fi

echo "🚀 Starting runner..."
exec ./run.sh
