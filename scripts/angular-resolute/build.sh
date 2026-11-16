#!/bin/bash
set -euo pipefail

DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-angular"
IMAGE_TAG="1.2"
BASE_TAG="1.0"
BASE_IMAGE="pepesan/core-ubuntu-resolute"
DOCKERFILE="dockerfile-kasm-ubuntu-resolute-desktop-angular"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/../.."

echo "Construyendo ${IMAGE_NAME}:${IMAGE_TAG} desde ${BASE_IMAGE}:${BASE_TAG}"
docker build \
  --build-arg BASE_TAG="${BASE_TAG}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  -f "${DOCKERFILE}" \
  .
