#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  installer.sh [--dir=PATH] [--ports=LIST] [--no-net] [--node=VERSION]
  installer.sh [TARGET_DIR] [PORTS]

Description:
  Installs the files into the target folder and, if present, updates .envrc.
  Named parameters take precedence over positional ones.

Options:
  --help               Show this help and exit.
  --dir=PATH           Target directory (otherwise you'll be prompted).
  --ports=LIST         Comma-separated ports to expose (e.g. "3000,5173").
                       Sentinel values to skip: "", -, ., none, no, 0
  --no-net             Set VENV_NET="false" in .envrc (if present).
  --node=VERSION       Set VENV_NODE_VERSION (e.g. "22-alpine").

Positionals (compat):
  TARGET_DIR           Target directory if --dir is not provided.
  PORTS                Ports list if --ports is not provided.

Examples:
  installer.sh --dir=/projects/app --ports=3000,5173 --node=22-alpine
  installer.sh --dir=/projects/app --no-net --node=22-alpine
  installer.sh /projects/app "3000,5173"
  installer.sh --dir /projects/app --ports none

Node Versions (Format: "${NODE_VERSION}-${DISTRIB}") :
  Node  version: 20 22 24
  Linux distrib: alpine trixie bookworm bullseye trixie-slim bookworm-slim bullseye-slim
EOF
}

# Show help if requested
for arg in "$@"; do
  if [ "$arg" = "--help" ]; then
    usage
    exit 0
  fi
done

# $1 = TARGET_DIR (positional, kept for compatibility)
# $2 = ENV_PORTS (positional, kept for compatibility) e.g. "3000,5173"
RAW_PORTS=""
RAW_NODE=""
NET_FLAG=true

# Simple named args: --dir=PATH --ports=LIST --no-net --node=VERSION
for arg in "$@"; do
  case "$arg" in
    --dir=*)   TARGET_DIR="${arg#*=}" ;;
    --ports=*) RAW_PORTS="${arg#*=}" ;;
    --no-net)  NET_FLAG=false ;;
    --node=*|--node-version=*) RAW_NODE="${arg#*=}" ;;
  esac
done

# Read target directory (if --dir=... not provided, fallback to positional/prompt)
if [ -z "${TARGET_DIR:-}" ]; then
  if [ -n "${1:-}" ] && [[ "${1:-}" != --* ]]; then
    TARGET_DIR="$1"
  else
    read -r -p "Installation directory [${PWD}]: " _ANS
    TARGET_DIR="${_ANS:-$PWD}"
  fi
fi

# Normalize
if command -v realpath >/dev/null 2>&1; then
  TARGET_DIR="$(realpath -m "$TARGET_DIR")"
fi

# Validate directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "[sandbox] error: target folder does not exist: $TARGET_DIR" >&2
  exit 1
fi

# Ports handling (fallback to positional/prompt if --ports not provided)
ASK_PORTS=false
if [ -z "${RAW_PORTS}" ]; then
  if [ $# -ge 2 ] && [[ "${2:-}" != --* ]]; then
    RAW_PORTS="$2"
  else
    ASK_PORTS=true
  fi
fi

if [ -n "${RAW_PORTS}" ]; then
  _low="${RAW_PORTS,,}"
  case "$_low" in
    ""|"-"|"."|"none"|"no"|"0")
      RAW_PORTS=""
      ASK_PORTS=false
      ;;
  esac
fi

if [ "$ASK_PORTS" = true ] && [ -z "${RAW_PORTS}" ]; then
  read -r -p "Ports to expose (comma-separated, empty to skip): " RAW_PORTS
fi

# Extraction
TAR_KEEP=""
MARK="__ARCHIVE_BELOW__"
LINE=$(awk "/^$MARK$/{print NR+1; exit 0}" "$0")

echo "[sandbox] extracting to: $TARGET_DIR"
tail -n +$LINE "$0" | tar -xz ${TAR_KEEP-} -C "$TARGET_DIR"

cd "$TARGET_DIR"

# Update .envrc only if present
if [ -f .envrc ]; then
  # VENV_PORTS
  if [ -n "${RAW_PORTS}" ]; then
    ENV_PORTS_CLEAN="$(printf '%s' "$RAW_PORTS" | tr -d ' ' | tr -cd '0-9,')"
    if [ -n "$ENV_PORTS_CLEAN" ]; then
      if grep -qE '^\s*#?\s*export\s+VENV_PORTS=' .envrc; then
        sed -E -i 's/^\s*#?\s*export\s+VENV_PORTS=.*/export VENV_PORTS="'"${ENV_PORTS_CLEAN}"'"/g' .envrc
      else
        printf '\nexport VENV_PORTS="%s"\n' "$ENV_PORTS_CLEAN" >> .envrc
      fi
      echo "[sandbox] configured VENV_PORTS=${ENV_PORTS_CLEAN} in $TARGET_DIR/.envrc"
    fi
  fi

  # VENV_NET (flag without value: presence => true; absence => untouched)
  if [ "$NET_FLAG" = false ]; then
    if grep -qE '^\s*#?\s*export\s+VENV_NET=' .envrc; then
      sed -E -i 's/^\s*#?\s*export\s+VENV_NET=.*/export VENV_NET="false"/g' .envrc
    else
      printf '\nexport VENV_NET="false"\n' >> .envrc
    fi

    echo "[sandbox] configured VENV_NET=false in $TARGET_DIR/.envrc"
  fi

  # VENV_NODE_VERSION (if provided)
  if [ -n "${RAW_NODE}" ]; then
    ENV_NODE_TRIM="$(printf '%s' "$RAW_NODE" | awk '{$1=$1;print}')"
    if [ -n "$ENV_NODE_TRIM" ]; then
      if grep -qE '^\s*#?\s*export\s+VENV_NODE_VERSION=' .envrc; then
        sed -E -i 's/^\s*#?\s*export\s+VENV_NODE_VERSION=.*/export VENV_NODE_VERSION="'"${ENV_NODE_TRIM}"'"/g' .envrc
      else
        printf '\nexport VENV_NODE_VERSION="%s"\n' "$ENV_NODE_TRIM" >> .envrc
      fi
      echo "[sandbox] configured VENV_NODE_VERSION=${ENV_NODE_TRIM} in $TARGET_DIR/.envrc"
    fi
  fi
fi

# Post-config
direnv allow
echo "[sandbox] done. (if .envrc present: run 'direnv allow')"

exit 0
__ARCHIVE_BELOW__
