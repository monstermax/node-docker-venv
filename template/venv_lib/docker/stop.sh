#!/bin/bash

cd `dirname $0`


if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi


# Stop docker container
if docker container inspect "${VENV_CONTAINER}" >/dev/null 2>&1; then
  docker stop ${VENV_CONTAINER}
  echo "Docker container stopped"
fi


if [[ " ${@} " =~ " --destroy " ]]; then
    # Destroy image
    docker rm -f ${VENV_CONTAINER}
    docker rmi ${VENV_IMAGE}
fi

