#!/usr/bin/env bash
set -euo pipefail

DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-ansible-dind"
IMAGE_TAG="1.4"

if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" &>/dev/null; then
  echo "Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}" >&2
  echo "Construye primero con scripts/ansible-resolute-dind/build.sh" >&2
  exit 1
fi

docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}:latest"
docker push "${IMAGE_NAME}:${IMAGE_TAG}"
docker push "${IMAGE_NAME}:latest"
