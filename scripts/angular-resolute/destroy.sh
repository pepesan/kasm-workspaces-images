#!/bin/bash
set -euo pipefail

CONTAINER_NAME="kasm-angular-resolute-test"
if docker ps -a --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; then
  docker rm -f "${CONTAINER_NAME}"
else
  echo "El contenedor ${CONTAINER_NAME} no existe"
fi
