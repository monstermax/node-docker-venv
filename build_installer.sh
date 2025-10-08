#!/bin/bash

cd `dirname $0`

mkdir -p dist

# Build archive
cd template
tar -czf /tmp/payload-ndv.tar.gz bin config venv_lib
cd ..

# Build installer
cat template_installer/installer.sh /tmp/payload-ndv.tar.gz > dist/node-venv-installer.sh
chmod +x dist/node-venv-installer.sh
rm -f /tmp/payload-ndv.tar.gz


echo "Script written into $(realpath ./dist/node-venv-installer.sh)"

