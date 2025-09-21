#!/bin/bash

cd `dirname $0`


ENV_DIR=$(realpath ./../..)
#echo ENV_DIR=$ENV_DIR
PROJECT_NAME=$(basename $ENV_DIR)



# If container does not exist, build it (by calling ./build.sh)
if ! docker image inspect "sandbox_$PROJECT_NAME" >/dev/null 2>&1; then
  ./build.sh
  echo "Docker image built"
fi


# Reads the list of ports
#echo SANDBOX_PORTS=$SANDBOX_PORTS

PORT_FLAGS=()
if [ -n "${SANDBOX_PORTS:-}" ]; then
  IFS=',' read -ra P <<<"$SANDBOX_PORTS"
  for p in "${P[@]}"; do
    p="${p//[[:space:]]/}"
    [ -n "$p" ] && PORT_FLAGS+=(-p "$p:$p")
  done
fi


# Run docker container
docker run -d --rm --name sandbox_${PROJECT_NAME} \
  -v ${ENV_DIR}:${ENV_DIR} \
  "${PORT_FLAGS[@]}" \
  sandbox_${PROJECT_NAME}


