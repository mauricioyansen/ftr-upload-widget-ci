FROM node:20.18 AS dependencies

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm i

COPY . .

RUN npm run build

RUN npm prune --prod

FROM gcr.io/distroless/nodejs22-debian12 AS deploy

USER 1000

WORKDIR /usr/src/app

COPY --from=dependencies /usr/src/app/dist ./dist
COPY --from=dependencies /usr/src/app/node_modules ./node_modules
COPY --from=dependencies /usr/src/app/package.json ./package.json

EXPOSE 3333

CMD ["dist/server.mjs"]