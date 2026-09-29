# Next.js Self-Hosted CI/CD Pipeline

[![CI](https://github.com/mortogo321/nextjs-github-workflows/actions/workflows/ci.yml/badge.svg)](https://github.com/mortogo321/nextjs-github-workflows/actions/workflows/ci.yml)
[![Next.js](https://img.shields.io/badge/Next.js-16-black)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19-61dafb)](https://react.dev/)
[![Bun](https://img.shields.io/badge/Bun-1.4-fbf0df)](https://bun.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

Demonstrates a self-hosted GitHub Actions runner deploying a containerized Next.js app to a server, with per-environment Docker Compose configs.

## What's inside

- Next.js application (`app/`) with TypeScript (strict) and Tailwind CSS
- `/api/health` endpoint for container healthchecks
- Dockerfile with multi-stage build (development/uat/production targets), bun-first installs, pinned Node 26 + Bun 1.4 images, non-root runtime, standalone output
- Docker Compose files per environment: `docker/compose.development.yml`, `compose.uat.yml`, `compose.production.yml` (ports + healthchecks)
- A containerized, self-hosted GitHub Actions runner (`github-runner/`) that registers itself against this repository
- CI (`.github/workflows/ci.yml`): lint + typecheck + test + build + docker build; Dependabot weekly
- A GitHub Actions deploy workflow (`.github/workflows/deploy-web.yml`, currently disabled — no deployment target) that, on push to `dev` or `main`, checks out the branch on the runner host and runs `docker compose build && up -d` against the matching compose file (uat for `dev`, production for `main`)

## Tech stack

- Next.js 16 (App Router, standalone output), React 19, TypeScript 5.9 (strict)
- Tailwind CSS 4, Vitest 5
- Bun 1.4 (package manager) / Node 26 (runtime)
- Docker / Docker Compose
- GitHub Actions self-hosted runner

## Quickstart

Local development:

```bash
git clone git@github.com:mortogo321/nextjs-github-workflows.git
cd nextjs-github-workflows/app
bun install
bun dev
```

Run checks:

```bash
bun run lint
bun run typecheck
bun run test
bun run build
```

Containerized development:

```bash
cd nextjs-github-workflows
docker compose -f docker/compose.development.yml up -d --build
```

App: http://localhost:8000 — health: http://localhost:8000/api/health

## Self-hosted runner

```bash
cd nextjs-github-workflows/github-runner
chmod +x *.sh
GH_RUNNER_TOKEN=<token> ./github-runner.sh
```

Builds and starts a Docker container running the GitHub Actions runner, registered to this repository with the `web,nextjs` labels used by the deploy workflow.

## Structure

```
app/                    # Next.js application (bun-first)
docker/                 # Per-environment Docker Compose files
github-runner/          # Self-hosted runner image and start script
.github/workflows/      # CI + (disabled) deploy workflow
```
