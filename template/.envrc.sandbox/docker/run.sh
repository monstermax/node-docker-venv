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


# If container does not exist, build it (by calling ./build.sh)
if ! docker image inspect "${VENV_CONTAINER}" >/dev/null 2>&1; then
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
docker run -d --rm --name ${VENV_CONTAINER} \
  -v ${VENV_DIR}:${VENV_DIR} \
  "${PORT_FLAGS[@]}" \
  ${VENV_CONTAINER}


