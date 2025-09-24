#!/bin/bash

cd `dirname $0`


if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi


# Stop docker container
docker stop ${VENV_CONTAINER}

#direnv deny
