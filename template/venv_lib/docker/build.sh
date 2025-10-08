#!/bin/bash

cd `dirname $0`

if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi

BASE_IMAGE="node:${VENV_NODE_VERSION}"

# Choose Dockerfile based on VENV_NODE_VERSION
DOCKERFILE="Dockerfile"
case "${VENV_NODE_VERSION}" in
  *alpine*) DOCKERFILE="Dockerfile.alpine" ;;
esac

echo "BUILDING image ${VENV_IMAGE} from base ${BASE_IMAGE} using ${DOCKERFILE}"

docker build \
  -f "${DOCKERFILE}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  -t "${VENV_IMAGE}" .
