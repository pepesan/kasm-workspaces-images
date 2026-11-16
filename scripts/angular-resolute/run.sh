#!/bin/bash
set -euo pipefail

IMAGE_NAME="pepesan/mi-ubuntu-resolute-kasm-angular"
IMAGE_TAG="1.2"
VNC_PASSWORD="${KASM_USER_PASSWORD:-sta3war2}"
PORT="${PORT:-6922}"
CONTAINER_NAME="kasm-angular-resolute-test"

if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1; then
  echo "Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}" >&2
  echo "Ejecuta primero: ./scripts/angular-resolute/build.sh" >&2
  exit 1
fi

if docker ps -a --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; then
  docker rm -f "${CONTAINER_NAME}"
fi

docker run -d \
  --name "${CONTAINER_NAME}" \
  --shm-size=512m \
  -e VNC_PW="${VNC_PASSWORD}" \
  -p "${PORT}:6901" \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo "Kasm Angular iniciado en https://localhost:${PORT} (usuario kasm_user)"
