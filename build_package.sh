#!/bin/bash

cd `dirname $0`

mkdir -p dist
cd template

# Build archive
tar -czf /tmp/payload.tar.gz .envrc.sandbox .envrc
cd -

# Build installer
cat template_installer/installer.sh /tmp/payload.tar.gz > dist/node-docker-venv.sh
chmod +x dist/node-docker-venv.sh
rm -f /tmp/payload.tar.gz
