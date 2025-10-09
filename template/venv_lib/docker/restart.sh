#!/bin/bash

cd `dirname $0`


if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi

if [ "$VENV_IMAGE" = "" ]; then
    echo "Error missing VENV_IMAGE"
    exit 1
fi


./stop.sh

if [[ " ${@} " =~ " --rebuild " ]]; then
    # Destroy image
    docker rm -f ${VENV_CONTAINER}
    docker rmi ${VENV_IMAGE}
fi

./run.sh

