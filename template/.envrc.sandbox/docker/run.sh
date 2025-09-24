#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

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

# build if needed
if ! docker image inspect "${VENV_IMAGE}" >/dev/null 2>&1; then
  ./build.sh
  echo "[+] Docker image built"
fi


# Ports mapping only allowed when network enabled
PORT_FLAGS=()
if [ -n "${VENV_PORTS:-}" ]; then
  IFS=',' read -ra P <<<"$VENV_PORTS"

  for p in "${P[@]}"; do
    p="${p//[[:space:]]/}"
    [ -n "$p" ] && PORT_FLAGS+=(-p "$p:$p")
  done
fi


# Determine user to run inside container (map to current host uid/gid)
USER_ID="$(id -u)"
GROUP_ID="$(id -g)"

# Resource limits (tunable)
MEM_LIMIT="${VENV_MEM_LIMIT:-512m}"
CPU_LIMIT="${VENV_CPU_LIMIT:-0.5}"   # 0.5 CPU by default
PIDS_LIMIT="${VENV_PIDS_LIMIT:-200}"


# Network flag
if [ "${VENV_NET:-true}" = true ]; then
  NETWORK_FLAG="bridge"
  echo "[!] Network enabled (bridge). Be careful."

else
  NETWORK_NAME="none"
fi


echo "RUNNING container ${VENV_CONTAINER}"

docker run -d --rm --name "${VENV_CONTAINER}" \
  --user "${USER_ID}:${GROUP_ID}" \
  --cap-drop ALL \
  --security-opt no-new-privileges \
  --pids-limit "${PIDS_LIMIT}" \
  --memory "${MEM_LIMIT}" --cpus "${CPU_LIMIT}" \
  --network "${NETWORK_FLAG}" \
  --read-only \
  --mount type=tmpfs,target=/tmp,tmpfs-mode=1777,tmpfs-size=134217728 \
  --tmpfs /home/node:rw,nosuid,noexec,uid=${USER_ID},gid=${GROUP_ID},mode=0755,size=10m \
  -v "${VENV_DIR}:${VENV_DIR}" \
  -w "${VENV_DIR}" \
  "${PORT_FLAGS[@]}" \
  "${VENV_IMAGE}"



# Note: pour tester le reseau dans le container => echo > /dev/tcp/8.8.8.8/53

