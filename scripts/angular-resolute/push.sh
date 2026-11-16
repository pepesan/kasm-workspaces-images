#!/bin/bash
set -euo pipefail

DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-angular"
IMAGE_TAG="1.2"

if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1; then
  echo "Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}" >&2
  echo "Ejecuta primero: ./scripts/angular-resolute/build.sh" >&2
  exit 1
fi

docker login
docker push "${IMAGE_NAME}:${IMAGE_TAG}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}:latest"
docker push "${IMAGE_NAME}:latest"

echo "Publicadas ${IMAGE_NAME}:${IMAGE_TAG} y ${IMAGE_NAME}:latest"
