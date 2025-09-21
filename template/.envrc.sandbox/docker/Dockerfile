FROM node:trixie-slim

RUN apt-get update && apt-get install -y ts-node

USER node

RUN npm config set prefix '/home/node/.local' && \
    npm config set cache '/home/node/.npm-cache' && \
    echo 'alias l="ls -l --color"' >> /home/node/.bashrc && \
    echo 'alias ll="ls -la --color"' >> /home/node/.bashrc && \
    echo 'export PATH="/home/node/.local/bin:$PATH"' >> /home/node/.bashrc

CMD ["tail", "-f", "/dev/null"]
