# Web (Next.js app)

Part of [nextjs-github-workflows](../README.md) — containerized Next.js app with per-environment Docker Compose configs.

## Scripts

```bash
bun install
bun dev         # local dev (Turbopack)
bun run lint
bun run typecheck
bun run test    # vitest (health route + home page)
bun run build
bun start
```

## Notes

- `output: "standalone"` in `next.config.ts` — the Docker runtime image serves `.next/standalone/server.js` as non-root on Node 26.
- `GET /api/health` returns `{ "status": "ok" }` — used by the Dockerfile `HEALTHCHECK` and Compose healthchecks.
- ESLint 9 + TypeScript 5.9 are pinned: ESLint 10 breaks `eslint-config-next`'s React plugin chain and TS 7 has no matching `typescript-estree` support yet.
