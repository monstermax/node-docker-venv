#!/bin/bash

cd `dirname $0`


if [ -z "${VENV_IMAGE:-}" ]; then
  echo "Error: missing VENV_IMAGE" >&2
  exit 1
fi

if [ -z "${VENV_CONTAINER:-}" ]; then
  echo "Error: missing VENV_CONTAINER" >&2
  exit 1
fi

if [ -z "${VENV_DIR:-}" ]; then
  echo "Error: missing VENV_DIR (project dir)" >&2
  exit 1
fi


# If image does not exist, build it (by calling ./build.sh)
if ! docker image inspect "${VENV_IMAGE}" >/dev/null 2>&1; then
  ./build.sh
  echo "Docker image built"
fi


# Reads the list of ports
PORT_FLAGS=()
if [ -n "${VENV_PORTS:-}" ]; then
  IFS=',' read -ra P <<<"$VENV_PORTS"
  for p in "${P[@]}"; do
    p="${p//[[:space:]]/}"
    [ -n "$p" ] && PORT_FLAGS+=(-p "$p:$p")
  done
fi


# Run docker container
echo "RUNNING container ${VENV_CONTAINER}"

docker run -d --rm --name ${VENV_CONTAINER} \
  -v ${VENV_DIR}:${VENV_DIR} \
  "${PORT_FLAGS[@]}" \
  "${VENV_IMAGE}"


