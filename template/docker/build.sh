#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

[ -z "${VENV_CONTAINER:-}" ] && echo "Error: VENV_CONTAINER is not set" >&2 && exit 1

BASE_IMAGE="node:${VENV_NODE_VERSION}"

DOCKERFILE="Dockerfile"
case "${VENV_NODE_VERSION}" in
  *alpine*) DOCKERFILE="Dockerfile.alpine" ;;
esac

echo "Building image ${VENV_IMAGE} from ${BASE_IMAGE} using ${DOCKERFILE}..."

docker build \
  -f "${DOCKERFILE}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  -t "${VENV_IMAGE}" .
