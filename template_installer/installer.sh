#!/usr/bin/env bash

set -euo pipefail

# TODO: ajouter argument ENV_PORTS=$2 en parametre de l'installer afin de pré-configurer .envrc => code à ajouter entre "cd $TARGET_DIR" et "direnv allow"


# Reading the target directory
if [ -n "${1:-}" ]; then
  TARGET_DIR="$1"
else
  read -r -p "Installation dir [${PWD}]: " _ANS
  TARGET_DIR="${_ANS:-$PWD}"
fi

# Standardization (optional)
if command -v realpath >/dev/null 2>&1; then
  TARGET_DIR="$(realpath -m "$TARGET_DIR")"
fi

# Refuse if the file does not exist
if [ ! -d "$TARGET_DIR" ]; then
  echo "[sandbox] error: target folder does not exist: $TARGET_DIR" >&2
  exit 1
fi

# Do not overwrite any existing files (GNU tar: --keep-old-files ; BSD tar: -k)
TAR_KEEP=""
#TAR_KEEP="--keep-old-files"

# Find the line where the archive starts and then extract
MARK="__ARCHIVE_BELOW__"
LINE=$(awk "/^$MARK$/{print NR+1; exit 0}" "$0")

echo "[sandbox] extraction in: $TARGET_DIR"
tail -n +$LINE "$0" | tar -xz ${TAR_KEEP-} -C "$TARGET_DIR"

cd $TARGET_DIR
direnv allow

echo "[sandbox] done. (if .envrc present: 'direnv allow')"
exit 0
__ARCHIVE_BELOW__
