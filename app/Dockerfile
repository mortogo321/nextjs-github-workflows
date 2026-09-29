# syntax=docker/dockerfile:1
ARG NODE_VERSION=26.10.0
ARG BUN_VERSION=1.4.2

# ---- deps (bun-first) ----
FROM oven/bun:${BUN_VERSION}-alpine AS deps
WORKDIR /app
COPY app/package.json app/bun.lock ./
RUN bun install --frozen-lockfile

# ---- builder ----
FROM oven/bun:${BUN_VERSION}-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app/ ./
ENV NEXT_TELEMETRY_DISABLED=1
RUN bun run build

# ---- production runner (non-root Node 26, Next standalone) ----
FROM node:${NODE_VERSION}-alpine AS runner-base
WORKDIR /app
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3000
RUN apk add --no-cache curl libc6-compat openssl && \
    addgroup -S nextjs && adduser -S nextjs -G nextjs
COPY --from=builder --chown=nextjs:nextjs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nextjs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nextjs /app/public ./public
USER nextjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://127.0.0.1:3000/api/health || exit 1
CMD ["node", "server.js"]

# ---- development (bun dev, HMR-friendly) ----
FROM oven/bun:${BUN_VERSION}-alpine AS development
WORKDIR /app
ENV NODE_ENV=development \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3000
COPY app/package.json app/bun.lock ./
RUN bun install --frozen-lockfile
COPY app/ ./
EXPOSE 3000
CMD ["bun", "run", "dev", "--hostname", "0.0.0.0", "--port", "3000"]

# ---- uat ----
FROM runner-base AS uat
ENV NODE_ENV=uat
COPY app/.env.uat .env

# ---- production ----
FROM runner-base AS production
ENV NODE_ENV=production
COPY app/.env.production .env
