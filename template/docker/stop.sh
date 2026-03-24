#!/bin/bash
set -euo pipefail

[ -z "${VENV_CONTAINER:-}" ] && echo "Error: VENV_CONTAINER is not set" >&2 && exit 1

if docker container inspect "${VENV_CONTAINER}" >/dev/null 2>&1; then
  docker stop "${VENV_CONTAINER}"
  echo "Container ${VENV_CONTAINER} stopped."
else
  echo "Container ${VENV_CONTAINER} is not running."
fi
