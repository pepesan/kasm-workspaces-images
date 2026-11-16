#!/usr/bin/env bash
set -euo pipefail

NOTEBOOK_DIR="${1:-$HOME}"
if [[ ! -d "$NOTEBOOK_DIR" ]]; then
  echo "No existe el directorio de trabajo: $NOTEBOOK_DIR" >&2
  exit 1
fi

cd "$NOTEBOOK_DIR"
echo "Jupyter Notebook disponible en este escritorio: http://127.0.0.1:8888"
echo "La URL de autenticacion con token se mostrara abajo. Pulsa Ctrl+C para detenerlo."
exec /opt/jupyter/bin/jupyter notebook \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --ServerApp.root_dir="$NOTEBOOK_DIR"
