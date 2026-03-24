# Docker: https://hub.docker.com/_/node
# Node versions : 20  22  24
# Debian distrib: bullseye  bookworm  trixie  (+ -slim variants)

ARG BASE_IMAGE=node:22-trixie-slim
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y node-typescript ts-node && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER node

ENV NPM_CONFIG_PREFIX=/home/node/.local \
    NPM_CONFIG_CACHE=/home/node/.npm-cache \
    PATH=/home/node/.local/bin:$PATH

RUN echo 'alias l="ls -l --color=auto"'  >> /home/node/.bashrc && \
    echo 'alias ll="ls -la --color=auto"' >> /home/node/.bashrc

CMD ["tail", "-f", "/dev/null"]
