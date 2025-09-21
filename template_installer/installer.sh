#!/usr/bin/env bash
set -euo pipefail

# --- lecture du répertoire cible ---
if [ -n "${1:-}" ]; then
  TARGET_DIR="$1"
else
  read -r -p "Chemin d'installation [${PWD}]: " _ANS
  TARGET_DIR="${_ANS:-$PWD}"
fi
# normalisation (optionnelle)
if command -v realpath >/dev/null 2>&1; then
  TARGET_DIR="$(realpath -m "$TARGET_DIR")"
fi

# refuser si le dossier n'existe pas
if [ ! -d "$TARGET_DIR" ]; then
  echo "[sandbox] erreur: le dossier cible n'existe pas: $TARGET_DIR" >&2
  exit 1
fi

# N'écraser aucun fichier existant (GNU tar: --keep-old-files ; BSD tar: -k)
TAR_KEEP="--keep-old-files"

# Trouve la ligne où commence l'archive puis extrait
MARK="__ARCHIVE_BELOW__"
LINE=$(awk "/^$MARK$/{print NR+1; exit 0}" "$0")

echo "[sandbox] extraction dans: $TARGET_DIR"
tail -n +$LINE "$0" | tar -xz $TAR_KEEP -C "$TARGET_DIR"

echo "[sandbox] fait. (si .envrc présent: 'direnv allow')"
exit 0
__ARCHIVE_BELOW__
