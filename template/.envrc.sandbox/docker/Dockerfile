
# Docker: https://hub.docker.com/_/node
# Github: https://github.com/nodejs/docker-node


# Standard versions
# Node 24 => node:24-{trixie,bookworm,bulleye,alpine}
# Node 22 => node:22-{trixie,bookworm,bulleye,alpine}
# Node 20 => node:20-{trixie,bookworm,bulleye,alpine}

# Slim versions
# Node 24 => node:24-{trixie-slim,bookworm-slim,bulleye-slim}
# Node 22 => node:22-{trixie-slim,bookworm-slim,bulleye-slim}
# Node 20 => node:20-{trixie-slim,bookworm-slim,bulleye-slim}

# Debian versions
# Debian 13 = trixie
# Debian 12 = bookworm
# Debian 11 = bulleye

#ARG BASE_IMAGE=node:24-trixie-slim
#ARG BASE_IMAGE=node:22-trixie-slim
#ARG BASE_IMAGE=node:20-trixie-slim
ARG BASE_IMAGE=node:22-bookworm


FROM $BASE_IMAGE

RUN apt-get update && apt-get install -y ts-node

USER node

RUN npm config set prefix '/home/node/.local' && \
    npm config set cache '/home/node/.npm-cache' && \
    echo 'alias l="ls -l --color"' >> /home/node/.bashrc && \
    echo 'alias ll="ls -la --color"' >> /home/node/.bashrc && \
    echo 'export PATH="/home/node/.local/bin:$PATH"' >> /home/node/.bashrc

CMD ["tail", "-f", "/dev/null"]
