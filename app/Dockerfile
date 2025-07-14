# variables
ARG IMAGE=node:alpine

# base
FROM ${IMAGE} AS base

RUN apk update && apk add --no-cache curl libc6-compat openssl

WORKDIR /app

COPY ../app/package.json ../app/yarn.lock ./

RUN yarn install --frozen-lockfile

COPY ../app .

RUN yarn build

# uat stage
FROM base AS uat

WORKDIR /app

COPY ../app/.env.uat .env
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/.next ./.next

EXPOSE 3000

CMD ["yarn", "start"]

# production stage
FROM base AS production

WORKDIR /app

COPY ../app/.env.production .env
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/.next ./.next

EXPOSE 3000

CMD ["yarn", "start"]
