#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

[ -z "${VENV_IMAGE:-}" ]     && echo "Error: VENV_IMAGE is not set" >&2 && exit 1
[ -z "${VENV_CONTAINER:-}" ] && echo "Error: VENV_CONTAINER is not set" >&2 && exit 1
[ -z "${VENV_DIR:-}" ]       && echo "Error: VENV_DIR is not set" >&2 && exit 1

# Build image if it doesn't exist yet
if ! docker image inspect "${VENV_IMAGE}" >/dev/null 2>&1; then
  ./build.sh
fi

# Resource limit flags
MEM_FLAG="${VENV_MEM_LIMIT:+--memory ${VENV_MEM_LIMIT}}"
CPU_FLAG="${VENV_CPU_LIMIT:+--cpus ${VENV_CPU_LIMIT}}"
PIDS_FLAG="${VENV_PIDS_LIMIT:+--pids-limit ${VENV_PIDS_LIMIT}}"

USER_ID="$(id -u)"
GROUP_ID="$(id -g)"

echo "Starting container ${VENV_CONTAINER}..."

docker run -d --rm \
  --name "${VENV_CONTAINER}" \
  --user "${USER_ID}:${GROUP_ID}" \
  --cap-drop ALL \
  --security-opt no-new-privileges \
  ${MEM_FLAG:-} \
  ${CPU_FLAG:-} \
  ${PIDS_FLAG:-} \
  --network host \
  --mount type=tmpfs,target=/tmp,tmpfs-mode=1777,tmpfs-size=134217728 \
  -v "${VENV_DIR}:${VENV_DIR}" \
  -w "${VENV_DIR}" \
  "${VENV_IMAGE}"
