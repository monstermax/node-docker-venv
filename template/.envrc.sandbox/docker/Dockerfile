FROM node:trixie-slim

RUN apt-get update && apt-get install -y ts-node

USER node

RUN npm config set prefix '/home/node/.local' && \
    npm config set cache '/home/node/.npm-cache' && \
    echo 'alias l="ls -l --color"' >> /home/node/.bashrc && \
    echo 'alias ll="ls -la --color"' >> /home/node/.bashrc && \
    echo 'export PATH="/home/node/.local/bin:$PATH"' >> /home/node/.bashrc

#WORKDIR /home/karma/dev
CMD ["tail", "-f", "/dev/null"]



# alias node=/home/monstermax/Documents/dockerfiles/nodejs/node.sh
# alias ts-node=/home/monstermax/Documents/dockerfiles/nodejs/ts-node.sh
# alias npm=/home/monstermax/Documents/dockerfiles/nodejs/npm.sh
