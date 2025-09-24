#!/bin/bash

cd `dirname $0`


if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi


BASE_IMAGE="node:${NODE_VERSION}"


# Build docker container
echo "BUILDING image ${VENV_IMAGE} from image ${BASE_IMAGE}"

docker build \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  -t "${VENV_IMAGE}" .

