#!/bin/bash
set -euo pipefail

CONTAINER_NAME="kasm-angular-resolute-test"
if docker ps --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; then
  docker stop "${CONTAINER_NAME}"
else
  echo "El contenedor ${CONTAINER_NAME} no está en ejecución"
fi
