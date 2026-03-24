#!/usr/bin/env bash
set -euo pipefail

# ─── Target directory ────────────────────────────────────────────────────────
# Priority: NDV_DIR env var > first positional arg > default
NDV_DIR="${NDV_DIR:-${1:-$HOME/.node-docker-venv}}"

# ─── Help ────────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
Usage:
  ./install.sh [TARGET_DIR]
  NDV_DIR=~/custom/path ./install.sh

Installs node-docker-venv into TARGET_DIR (default: ~/.node-docker-venv).
EOF
}

for arg in "$@"; do
  [ "$arg" = "--help" ] && usage && exit 0
done

# ─── Install ─────────────────────────────────────────────────────────────────
echo "Installing node-docker-venv into: $NDV_DIR"

mkdir -p "$NDV_DIR"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Remove stale files/dirs from older versions that would conflict
rm -rf "$NDV_DIR/bin/wrapper"

cp -a "$SCRIPT_DIR/template/." "$NDV_DIR/"
chmod +x "$NDV_DIR"/bin/*
chmod +x "$NDV_DIR"/docker/*.sh

# ─── Symlink node-venv-init into ~/.local/bin ─────────────────────────────
mkdir -p "$HOME/.local/bin"
ln -fs "$NDV_DIR/bin/node-venv-init" "$HOME/.local/bin/node-venv-init"

echo ""
echo "Done. Go to your project directory and run: node-venv-init"
echo ""
echo "Make sure ~/.local/bin is in your PATH and direnv is installed."
