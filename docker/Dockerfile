############################################
# Healthcheck Binary
############################################
FROM cmcooper1980/dockge:build-healthcheck AS build_healthcheck

############################################
# Build frontend
############################################
FROM cmcooper1980/dockge:base AS build_frontend
WORKDIR /app
COPY --chown=node:node . .
RUN --mount=type=cache,id=npm,target=/npm/store \
    npm install && \
    npm run build:frontend

############################################
# Install node modules
############################################
FROM cmcooper1980/dockge:base AS build_nodemodules
WORKDIR /app
COPY --chown=node:node  ./package.json ./package.json
COPY --chown=node:node  ./package-lock.json ./package-lock.json
RUN npm ci --omit=dev

############################################
# ⭐ Main Image
############################################
FROM cmcooper1980/dockge:base AS release
WORKDIR /app
COPY --chown=node:node --from=build_healthcheck /app/extra/healthcheck /app/extra/healthcheck
COPY --from=build_frontend /app/frontend-dist /app/frontend-dist
COPY --from=build_nodemodules /app/node_modules /app/node_modules
COPY --chown=node:node . .
RUN mkdir ./data

# Add start script
COPY start-with-init.sh /usr/local/bin/start-with-init.sh
RUN chmod +x /usr/local/bin/start-with-init.sh

# It is just for safe, as by default, it is disabled in the latest Node.js now.
ENV UV_USE_IO_URING=0

VOLUME /app/data
EXPOSE 5001
HEALTHCHECK --interval=60s --timeout=30s --start-period=60s --retries=5 CMD extra/healthcheck

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/start-with-init.sh"]

############################################
# Mark as Nightly
############################################
#FROM release AS nightly
#RUN npm run mark-as-nightly
