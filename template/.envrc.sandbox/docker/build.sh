#!/bin/bash

cd `dirname $0`


#VENV_DIR=$(realpath ./../..)
#VENV_PROJECT=$(basename $VENV_DIR)
#VENV_CONTAINER=sandbox_${VENV_PROJECT}

if ! hasDocker; then
    echo "Error Docker not found"
    exit 1
fi

if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi


# Build
docker build -t ${VENV_CONTAINER} .

