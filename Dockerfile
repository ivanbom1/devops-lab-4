FROM node:20 AS build
ARG GITHUB_SHA=local-dev
ENV GITHUB_SHA=$GITHUB_SHA
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=build /app/server.js ./server.js
COPY --from=build /app/public ./public
COPY --from=build /app/dist/build-manifest.json ./dist/build-manifest.json
USER node
EXPOSE 4173
CMD ["node", "server.js"]