# Nextjs Github Workflows
- Next.js

## Development
``` bash
# installation
git clone git@github.com:mortogo321/nextjs-github-workflows.git
cd nextjs-github-workflows/app
yarn
```

## Github runner
``` bash
cd nextjs-github-workflows/github-runner
./github-runner.sh GITHUB_RUNNER_TOKEN
```

## Dockerize
``` bash
cd nextjs-github-workflows

# up
docker compose -f "docker/compose.development.yml" up -d --build

# down
docker compose -f "docker/compose.development.yml" down --rmi all --remove-orphans
```

## Services
APP: http://localhost:3000
