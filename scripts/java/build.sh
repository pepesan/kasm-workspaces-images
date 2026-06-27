#!/bin/bash

set -e

# ============================================
# CONFIGURACIÓN - Edita estos valores
# ============================================
DOCKER_USER="pepesan"          # ← Tu username de Docker Hub
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-noble-kasm"
IMAGE_TAG="1.0"
BASE_TAG="1.16.0"
BASE_IMAGE="core-ubuntu-noble"
DOCKERFILE="dockerfile-kasm-ubuntu-noble-desktop-custom"
USER_PASSWORD="sta3war2"
# ============================================

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}==============================${NC}"
echo -e "${YELLOW}  Construyendo imagen Kasm    ${NC}"
echo -e "${YELLOW}==============================${NC}"
echo ""
echo -e "  Imagen:     ${GREEN}${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo -e "  Base:       ${GREEN}kasmweb/${BASE_IMAGE}:${BASE_TAG}${NC}"
echo -e "  Dockerfile: ${GREEN}${DOCKERFILE}${NC}"
echo ""

# Ir a la raíz del proyecto (un nivel arriba de scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/../.."

# Construir
docker build \
  --build-arg BASE_TAG="${BASE_TAG}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  --build-arg USER_PASSWORD="${USER_PASSWORD}" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  -f "${DOCKERFILE}" \
  .

echo ""
echo -e "${GREEN}✔ Imagen construida: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"