#!/usr/bin/env bash
set -euo pipefail

DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-ansible-dind"
IMAGE_TAG="1.4"
VNC_PASSWORD="${KASM_USER_PASSWORD:-ansiblelab}"
PORT="6921"
CONTAINER_NAME="kasm-ansible-resolute-dind-test"

if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" &>/dev/null; then
  echo "Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}" >&2
  echo "Construye primero con scripts/ansible-resolute-dind/build.sh" >&2
  exit 1
fi

if docker container inspect "${CONTAINER_NAME}" &>/dev/null; then
  docker rm -f "${CONTAINER_NAME}"
fi

docker run -d \
  --privileged \
  --name "${CONTAINER_NAME}" \
  --shm-size=512m \
  -e VNC_PW="${VNC_PASSWORD}" \
  -p "${PORT}:6901" \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo "Kasm URL: https://localhost:${PORT}"
echo "Usuario: kasm_user"
echo "Contraseña: ${VNC_PASSWORD}"
echo "Docker interno: docker exec ${CONTAINER_NAME} docker info"
