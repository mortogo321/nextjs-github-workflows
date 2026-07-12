# Next.js Self-Hosted CI/CD Pipeline

Demonstrates a self-hosted GitHub Actions runner deploying a containerized Next.js app to a server, with per-environment Docker Compose configs.

## What's inside

- Next.js application (`app/`) with TypeScript and Tailwind CSS
- Dockerfile with a multi-stage build (development/production targets)
- Docker Compose files per environment: `docker/compose.development.yml`, `compose.uat.yml`, `compose.production.yml`
- A containerized, self-hosted GitHub Actions runner (`github-runner/`) that registers itself against this repository
- A GitHub Actions workflow (`.github/workflows/deploy-web.yml`) that, on push to `dev` or `main`, checks out the branch on the runner host and runs `docker compose build && up -d` against the matching compose file (uat for `dev`, production for `main`)

## Tech stack

- Next.js (App Router), React, TypeScript
- Tailwind CSS
- Docker / Docker Compose
- GitHub Actions self-hosted runner

## Quickstart

Local development:

```bash
git clone git@github.com:mortogo321/nextjs-github-workflows.git
cd nextjs-github-workflows/app
yarn
yarn dev
```

Containerized development:

```bash
cd nextjs-github-workflows
docker compose -f docker/compose.development.yml up -d --build
```

App: http://localhost:8000

## Self-hosted runner

```bash
cd nextjs-github-workflows/github-runner
chmod +x *.sh
GH_RUNNER_TOKEN=<token> ./github-runner.sh
```

Builds and starts a Docker container running the GitHub Actions runner, registered to this repository with the `web,nextjs` labels used by the deploy workflow.

## Structure

```
app/                    # Next.js application
docker/                 # Per-environment Docker Compose files
github-runner/          # Self-hosted runner image and start script
.github/workflows/      # CI/CD workflow (deploy-web.yml)
```
