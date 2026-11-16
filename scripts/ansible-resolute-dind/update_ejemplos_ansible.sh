#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${HOME}/ejemplos-ansible"

if [[ ! -d "${REPO_DIR}/.git" ]]; then
  echo "ERROR: No existe el repositorio Git en ${REPO_DIR}." >&2
  exit 1
fi

printf 'Actualizando los ejemplos de Ansible en %s...\n\n' "${REPO_DIR}"
if git -C "${REPO_DIR}" pull --ff-only; then
  printf '\nRepositorio actualizado. Commit actual: '
  git -C "${REPO_DIR}" log -1 --format='%h %s'
else
  status=$?
  printf '\nNo se pudo actualizar. Se conservan los cambios locales.\n' >&2
  printf 'Revisa el estado con: git -C %q status\n' "${REPO_DIR}" >&2
  read -r -p 'Pulsa Enter para cerrar esta ventana...' _ || true
  exit "${status}"
fi

read -r -p 'Pulsa Enter para cerrar esta ventana...' _ || true
