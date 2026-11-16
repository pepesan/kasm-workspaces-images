#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="pepesan/mi-ubuntu-resolute-kasm-jupyter-dind"
IMAGE_TAG="1.3"
BASE_TAG="1.20"
BASE_IMAGE="pepesan/core-ubuntu-resolute"
DOCKERFILE="dockerfile-kasm-ubuntu-resolute-desktop-jupyter-dind"
REPOS_REV="$(date +%s)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/../.."

echo "Construyendo ${IMAGE_NAME}:${IMAGE_TAG} desde ${BASE_IMAGE}:${BASE_TAG}"
docker build \
  --build-arg BASE_TAG="${BASE_TAG}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  --build-arg REPOS_REV="${REPOS_REV}" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  -f "${DOCKERFILE}" \
  .

echo "Imagen construida: ${IMAGE_NAME}:${IMAGE_TAG}"
