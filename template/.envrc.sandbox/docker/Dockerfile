
# Docker: https://hub.docker.com/_/node
# Github: https://github.com/nodejs/docker-node


# Standard versions
# Node 24 => node:24-{trixie,bookworm,bullseye}
# Node 22 => node:22-{trixie,bookworm,bullseye}
# Node 20 => node:20-{trixie,bookworm,bullseye}

# Slim versions
# Node 24 => node:24-{trixie-slim,bookworm-slim,bullseye-slim}
# Node 22 => node:22-{trixie-slim,bookworm-slim,bullseye-slim}
# Node 20 => node:20-{trixie-slim,bookworm-slim,bullseye-slim}

# Debian versions
# Debian 13 = trixie
# Debian 12 = bookworm
# Debian 11 = bullseye

#ARG BASE_IMAGE=node:24-trixie-slim
#ARG BASE_IMAGE=node:22-trixie-slim
#ARG BASE_IMAGE=node:20-trixie-slim
ARG BASE_IMAGE=node:22-trixie-slim


FROM $BASE_IMAGE

RUN apt-get update && apt-get install -y ts-node && apt-get clean

USER node


# npm config & shell aliases
ENV NPM_CONFIG_PREFIX=/home/node/.local \
    NPM_CONFIG_CACHE=/home/node/.npm-cache \
    PATH=/home/node/.local/bin:$PATH


RUN echo 'alias l="ls -l --color=auto"' >> /home/node/.bashrc && \
    echo 'alias ll="ls -la --color=auto"' >> /home/node/.bashrc


#RUN npm config set prefix '/home/node/.local' && \
#    npm config set cache '/home/node/.npm-cache' && \
#    echo 'alias l="ls -l --color"' >> /home/node/.bashrc && \
#    echo 'alias ll="ls -la --color"' >> /home/node/.bashrc && \
#    echo 'export PATH="/home/node/.local/bin:$PATH"' >> /home/node/.bashrc


CMD ["tail", "-f", "/dev/null"]
