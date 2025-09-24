#!/usr/bin/env bash
set -euo pipefail

# $1 = TARGET_DIR
# $2 = ENV_PORTS (facultatif) ex: "3000,5173"
RAW_PORTS=""


# Lecture du dossier cible
if [ -n "${1:-}" ]; then
  TARGET_DIR="$1"
else
  read -r -p "Installation dir [${PWD}]: " _ANS
  TARGET_DIR="${_ANS:-$PWD}"
fi

# Normalisation
if command -v realpath >/dev/null 2>&1; then
  TARGET_DIR="$(realpath -m "$TARGET_DIR")"
fi

# Dossier valide ?
if [ ! -d "$TARGET_DIR" ]; then
  echo "[sandbox] error: target folder does not exist: $TARGET_DIR" >&2
  exit 1
fi


# Gestion du 2e paramètre (ports)
ASK_PORTS=false
if [ $# -ge 2 ]; then
  RAW_PORTS="$2"
  _low="${RAW_PORTS,,}"
  case "$_low" in
    ""|"-"|"."|"none"|"no"|"0")
      RAW_PORTS=""
      ;;
    *)
      # valeur fournie et non-sentinelle -> on garde tel quel
      ;;
  esac
else
  # pas de 2e paramètre -> demander
  ASK_PORTS=true
fi

if [ "$ASK_PORTS" = true ]; then
  read -r -p "Ports to expose (comma-separated, empty to skip): " RAW_PORTS
fi


# Extraction
TAR_KEEP=""
MARK="__ARCHIVE_BELOW__"
LINE=$(awk "/^$MARK$/{print NR+1; exit 0}" "$0")

echo "[sandbox] extraction in: $TARGET_DIR"
tail -n +$LINE "$0" | tar -xz ${TAR_KEEP-} -C "$TARGET_DIR"

cd "$TARGET_DIR"


# Pré-config .envrc uniquement si .envrc existe ET si on a des ports non vides
if [ -n "${RAW_PORTS}" ] && [ -f .envrc ]; then
  # Nettoyage: retire espaces et tout sauf chiffres/virgules
  ENV_PORTS_CLEAN="$(printf '%s' "$RAW_PORTS" | tr -d ' ' | tr -cd '0-9,')"
  if [ -n "$ENV_PORTS_CLEAN" ]; then
    if grep -qE '^\s*#?\s*export\s+VENV_PORTS=' .envrc; then
      sed -E -i "s/^\s*#?\s*export\s+VENV_PORTS=.*/export VENV_PORTS=\"${ENV_PORTS_CLEAN}\"/g" .envrc
    else
      printf '\nexport VENV_PORTS="%s"\n' "$ENV_PORTS_CLEAN" >> .envrc
    fi
    echo "[sandbox] configured VENV_PORTS=${ENV_PORTS_CLEAN} in $TARGET_DIR/.envrc"
  fi
elif [ -n "${RAW_PORTS}" ] && [ ! -f .envrc ]; then
  echo "[sandbox] note: .envrc not found; skipping VENV_PORTS pre-config."
fi

# Post-config
direnv allow
echo "[sandbox] done. (if .envrc present: 'direnv allow')"

# End of script
exit 0
__ARCHIVE_BELOW__
