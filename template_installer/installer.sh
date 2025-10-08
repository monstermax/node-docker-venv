#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  installer.sh

Description:
  Installs the files into the target folder and, if present, updates .envrc.
  Named parameters take precedence over positional ones.
EOF
}


# Show help if requested
for arg in "$@"; do
  if [ "$arg" = "--help" ]; then
    usage
    exit 0
  fi
done


TARGET_DIR=$HOME/.node-docker-venv
mkdir -p $TARGET_DIR


# Validate directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: target folder does not exist: $TARGET_DIR" >&2
  exit 1
fi



# Extraction
MARK="__ARCHIVE_BELOW__"
LINE=$(awk "/^$MARK$/{print NR+1; exit 0}" "$0")

tail -n +$LINE "$0" | tar -xz -C "$TARGET_DIR"

echo "Node-Docker-Venv installed into: $TARGET_DIR"

mkdir -p $HOME/.local/bin
#cp -a ${TARGET_DIR}/bin/node-venv $HOME/.local/bin
cd $HOME/.local/bin
ln -fs ${TARGET_DIR}/bin/node-venv

exit 0
__ARCHIVE_BELOW__
