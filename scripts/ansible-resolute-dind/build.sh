#!/usr/bin/env bash
set -euo pipefail

DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-ansible-dind"
IMAGE_TAG="1.4"
BASE_TAG="1.20"
BASE_IMAGE="pepesan/core-ubuntu-resolute"
DOCKERFILE="dockerfile-kasm-ubuntu-resolute-ansible-dind"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/../.."

echo "Construyendo ${IMAGE_NAME}:${IMAGE_TAG} desde ${BASE_IMAGE}:${BASE_TAG}"
docker build \
  --build-arg BASE_TAG="${BASE_TAG}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  -f "${DOCKERFILE}" \
  .

echo "Imagen construida: ${IMAGE_NAME}:${IMAGE_TAG}"
